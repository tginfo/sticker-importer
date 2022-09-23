import 'dart:async';
import 'package:flutter/material.dart';

enum ExportControllerState {
  stopped,
  warmingUp,
  working,
  paused,
  retrying,
  error,
  done,
}

abstract class ExportController {
  ExportController({
    required this.onStyleChooser,
    required this.onShouldUseAnimated,
  });

  int get processed;
  int? get count;
  List<String>? get result;
  List<Set<String>>? get emojiSuggestions;
  List<String>? get previews;
  bool get isAnimated;
  final Future<StickerStyle> Function(List<StickerStyle> styles) onStyleChooser;
  final Future<bool> Function() onShouldUseAnimated;

  String? errorDetails;
  final StreamController<Function> _notifier = StreamController();
  Stream<Function>? _broadcast;
  Stream<Function> get notifier => _broadcast!;

  void setState(Function f) {
    _notifier.add(f);
  }

  ExportControllerState state = ExportControllerState.stopped;

  void init() {
    _broadcast ??= _notifier.stream.asBroadcastStream();
    warmup().onError((error, stackTrace) {
      setState(() {
        state = ExportControllerState.error;
        errorDetails = stackTrace.toString();
      });
      if (error != null) throw error;
    });
  }

  Future<void> warmup() {
    return worker().onError((error, stackTrace) {
      setState(() {
        state = ExportControllerState.error;
        errorDetails = stackTrace.toString();
      });
      if (error != null) throw error;
    });
  }

  Future<void> worker();

  void stop() {
    setState(() {
      state = ExportControllerState.stopped;
    });
  }
}

class StickerStyle {
  final String title;
  final Image image;
  final int id;
  final bool isAnimated;
  final List<int> stickerIds;

  const StickerStyle({
    required this.title,
    required this.image,
    required this.id,
    required this.isAnimated,
    required this.stickerIds,
  });
}
