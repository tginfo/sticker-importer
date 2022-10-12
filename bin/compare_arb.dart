#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

class L10nFile {
  final String path;
  final Map<String, dynamic> content;
  late final List<String> keys;
  final Set<L10nDiffItem> missing = {};

  L10nFile(this.path, this.content) {
    keys = content.keys.toList();
    keys.sort();
  }

  bool containsKey(String key) {
    return keys.contains(key);
  }

  void addMissing(String key, String foundIn) {
    missing.add(L10nDiffItem(key, foundIn));
  }
}

class L10nDiffItem {
  final String key;
  final String foundIn;

  const L10nDiffItem(this.key, this.foundIn);

  @override
  String toString() {
    return '$key (found in $foundIn)';
  }

  @override
  bool operator ==(Object other) {
    if (other is L10nDiffItem) {
      return key == other.key;
    }
    return false;
  }

  @override
  int get hashCode => key.hashCode;
}

class L10nDiff {
  final List<L10nFile> files;
  bool dirty = false;

  L10nDiff(this.files);

  void compare() {
    for (var i = 0; i < files.length; i++) {
      final file = files[i];
      for (var j = 0; j < files.length; j++) {
        if (i == j) continue;
        final other = files[j];
        for (final key in other.keys) {
          if (!file.containsKey(key)) {
            file.addMissing(key, basename(other.path));
            dirty = true;
          }
        }
      }
    }
  }
}

class L10FDiffResultPrinter {
  final L10nDiff diff;

  L10FDiffResultPrinter(this.diff);

  void startPrinting() {
    if (!diff.dirty) {
      print('Localization files are in sync');
      return;
    }

    for (final file in diff.files) {
      if (file.missing.isEmpty) {
        continue;
      }

      print('${basename(file.path)}:');
      for (final key in file.missing) {
        print('\t$key');
      }
    }
  }
}

int main() {
  final files = Directory('${dirname(Platform.script.path)}/../l10n/')
      .listSync()
      .where((element) => element is File && extension(element.path) == '.arb')
      .map(
        (e) => L10nFile(
          e.path,
          json.decode(
            File(e.path).readAsStringSync(),
          ) as Map<String, dynamic>,
        ),
      )
      .toList();

  final diff = L10nDiff(files);
  diff.compare();

  final printer = L10FDiffResultPrinter(diff);
  printer.startPrinting();

  if (diff.dirty) {
    exit(1);
  }

  return 0;
}
