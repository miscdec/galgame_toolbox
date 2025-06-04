import 'dart:io';

import 'package:flutter/foundation.dart';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

Directory getProgramWorkingPath(){
  return Directory.current;
}

Directory? getExecutablePathForDesktop() {
  if (isDesktop) {
    var exePath =  Platform.resolvedExecutable;
    return File(exePath).parent;
  }
  return null;
}

bool isPortableMode() {
  return isDesktop && fileExistsSync("${getExecutablePathForDesktop()?.path}/.portable");
}

Future<bool> fileExists(String path) async {
  return await File(path).exists();
}

bool fileExistsSync(String path){
  return File(path).existsSync();
}
