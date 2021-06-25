import 'dart:async';

import 'package:flutter/foundation.dart';

class LoadThrottlerTask<T> {
  LoadThrottlerTask(this.task);

  final Future<T> Function() task;
  final Completer<T> completer = Completer();
}

class LoadThrottler<T> {
  LoadThrottler(this.delay, this.parallelTasks);

  final Duration delay;
  final int parallelTasks;

  final List<LoadThrottlerTask<T>> _tasks = [];
  int _currentlyActiveTasks = 0;
  DateTime _lastTaskStart = DateTime.fromMicrosecondsSinceEpoch(0);
  bool _isBusy = false;

  void _runTask(LoadThrottlerTask<T> task) async {
    try {
      task.completer.complete(await task.task());
    } catch (e) {
      task.completer.completeError(e);
    }
    _currentlyActiveTasks--;
    _runQueue(isRecursive: true);
  }

  void _runQueue({isRecursive = false}) async {
    if (!isRecursive && _isBusy) return;
    if (_tasks.isEmpty) return;

    if (_currentlyActiveTasks >= parallelTasks) return;

    final d = DateTime.now().difference(_lastTaskStart);
    if (d < delay) {
      await Future.delayed(d);
    }

    while (_currentlyActiveTasks < parallelTasks && _tasks.isNotEmpty) {
      final task = _tasks.removeAt(0);
      Timer(delay * _currentlyActiveTasks, () {
        _runTask(task);
      });
      _lastTaskStart = DateTime.now();
      _currentlyActiveTasks++;
    }
  }

  Future<T> invoke(Future<T> Function() task) {
    final r = LoadThrottlerTask<T>(task);
    _tasks.add(r);

    if (!_isBusy) {
      _isBusy = false;
      _runQueue();
    }

    return r.completer.future;
  }
}

class DebouncedFuture<T> {
  DebouncedFuture(this.delay);

  final Duration delay;

  Completer<T>? _completer;
  Future<T> Function()? _nextTask;
  Timer? _lastTimer;

  Future<T> get future {
    if (_completer == null) {
      throw Exception('Nothing to await');
    }

    return _completer!.future;
  }

  @mustCallSuper
  void invoke(Future<T> Function() task) {
    if (_completer == null) {
      _completer = Completer();
      _nextTask = task;
    } else {
      _lastTimer!.cancel();
      _nextTask = task;
    }

    _lastTimer = Timer(delay, () async {
      final completer = _completer!;
      final nextTask = _nextTask!;

      _completer = null;
      _nextTask = null;
      _lastTimer = null;

      try {
        completer.complete(await nextTask());
      } catch (e) {
        completer.completeError(e);
      }
    });
  }
}
