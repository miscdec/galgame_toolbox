

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:galgame_toolbox/utils/platform.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getDataStorageDir() async {
  if (isPortableMode()) {
    return File(Platform.resolvedExecutable).parent;
  } else {
    return await getApplicationSupportDirectory();
  }
}

Future<String> getDataStoragePath({required String dir}) async {
  return "${(await getDataStorageDir()).path}/$dir";
}

Future<Directory> getDBStorage() async {
  final dir = await getDataStorageDir();
  final dbDir = Directory("${dir.path}/database");
  if (!dbDir.existsSync()) {
    dbDir.createSync();
  }
  return dbDir;
}

Directory? getDBStoragePath() {
  getDBStorage().then((dir) {
    final dbDir = Directory("${dir.path}/database");
    if (!dbDir.existsSync()) {
      dbDir.createSync();
    }
    return dbDir;
  });
  return null;
}

File checkAndRequestDBFile(String name) {
  final dbDir = getDBStoragePath();
  final dbFile = File("$dbDir/$name.sqlite3");
  if (!dbFile.existsSync()) {
    dbFile.createSync();
  }
  return dbFile;
}

String generateRandomKey() {
  final key = List.generate(32, (index) => Random.secure().nextInt(256)).toList();
  var encryptedKey = base64Url.encode(key);
  if(kDebugMode) {
    print("encryptedKey: $encryptedKey");
  }
  return encryptedKey;
}

scanSoftwareShortcuts ({String path = "/shortcuts"}) async {
  final dir = await getDataStorageDir();
  final shortcutDir = Directory(dir.path + path);
  if (!shortcutDir.existsSync()) {
    shortcutDir.createSync();
  }
  final shortcutFiles = shortcutDir.listSync();
  for (var file in shortcutFiles) {
    if (file is File) {
      final fileName = file.path.split("/").last;
      final fileNameWithoutExt = fileName.split(  ".").last;

    }
  }
 }
