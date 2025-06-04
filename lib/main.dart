import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:galgame_toolbox/service_locator.dart';
import 'package:galgame_toolbox/utils/drift.dart';
import 'package:system_theme/system_theme.dart';

import 'application.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();

  // if it's not on the web, windows or android, load the accent color
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }

  ServiceLocator.init();

  if(Platform.isAndroid) setupSqlCipher();



  Application app = Application();
  app.mainEntry(args);

}



