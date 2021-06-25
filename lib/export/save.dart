import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_operations;

abstract class SaveController {
  Future<void> init({int? id});

  Future<void> save({
    required Directory name,
    required String contents,
    FileMode mode = FileMode.write,
  });

  Future<String> read({
    required Directory name,
  });

  Future<List<Directory>> readDirectory({
    required Directory name,
  });

  Future<void> delete({
    required Directory name,
  });
}

class AppDocsSaveController implements SaveController {
  Directory docPath = Directory('./');

  Directory _getPath(Directory path) {
    return Directory(path_operations.join(
      docPath.toString(),
      path.toString(),
    ));
  }

  @override
  Future<void> init({int? id}) async {
    docPath = await getApplicationDocumentsDirectory();

    if (id != null) {
      docPath = Directory(path_operations.join(
        docPath.toString(),
        'transfers/$id',
      ));
    }
  }

  @override
  Future<void> delete({required Directory name}) async {
    await _getPath(name).delete(recursive: true);
  }

  @override
  Future<String> read({required Directory name}) async {
    return File(_getPath(name).toString()).readAsString();
  }

  @override
  Future<List<Directory>> readDirectory({required Directory name}) async {
    final res = <Directory>[];

    await for (var item in _getPath(name).list()) {
      res.add(Directory(item.path));
    }

    return res;
  }

  @override
  Future<void> save(
      {required Directory name,
      required String contents,
      FileMode mode = FileMode.write}) async {
    if (mode != FileMode.write || mode != FileMode.append) {
      throw Exception('Unsupported mode');
    }

    await File(_getPath(name).toString()).writeAsString(
      contents,
      mode: (mode == FileMode.write
          ? FileMode.writeOnly
          : FileMode.writeOnlyAppend),
    );
  }
}
