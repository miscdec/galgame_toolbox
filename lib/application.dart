import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galgame_toolbox/screens/app_home/home_page.dart';
import 'package:galgame_toolbox/screens/launcher.dart';
import 'package:galgame_toolbox/screens/shortcut.dart';
import 'package:galgame_toolbox/service_locator.dart';
import 'package:galgame_toolbox/utils/platform.dart';
import 'package:galgame_toolbox/window_communicate/window_communicate_sample.dart';
import 'package:galgame_toolbox/windows/main_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'create_window/create_window_sample.dart';


enum RunningMode { test, profile, release }
// final win = Platform.isWindows;
// Size AppSize = const Size(956, 590);

class ApplicationType {
  final RunningMode runningMode;

  ApplicationType({required this.runningMode});
}

DesktopWindowControl control = DesktopWindowControl();

abstract class Run {
  void runType(ApplicationType type);

  Future start(ApplicationType type);

  RunningMode get currentRunningMode;

  Future configWindow();

  void handleMultiWindow(List<String> args);

  void mainEntry(List<String> args);
}

class Application implements Run {

  @override
  void runType(ApplicationType type) {
    runApp(
      // const MaterialApp(
      //   home: Scaffold(
      //     body: CreateWindowSample(),
      //   ),
      // )
      MultiBlocProvider(
          providers: [
            BlocProvider<GridLayoutSizeBloc>(
              create: (BuildContext context) => di<GridLayoutSizeBloc>()..add(
                const SwitchGridSize(GridLayoutSize.medium)
              ) ,
            ),
            BlocProvider<HomePageBloc>(
              create: (BuildContext context) => di<HomePageBloc>()..add(
                const FetchAppCategory()
              ) ,
            ),
            BlocProvider<LayoutBloc>(
              create: (BuildContext context) => di<LayoutBloc>(),
            )
          ],
          child: const MainApp()
      )
    );
  }

  @override
  RunningMode get currentRunningMode {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return RunningMode.test;
    if (kReleaseMode) return RunningMode.release;
    return RunningMode.profile;
  }

  @override
  Future start(ApplicationType type) async {
    if (type.runningMode != RunningMode.test) {
      configWindow();
      runType(type);
    }
  }

  @override
  Future configWindow() async {

    if (isDesktop) {
      await flutter_acrylic.Window.initialize();
      if (defaultTargetPlatform == TargetPlatform.windows) {
        await flutter_acrylic.Window.hideWindowControls();
      }
      await windowManager.ensureInitialized();
      windowManager.waitUntilReadyToShow().then((_) async {
        await windowManager.setTitleBarStyle(
          TitleBarStyle.hidden,
          windowButtonVisibility: false,
        );
        // await windowManager.setAsFrameless();
        // await windowManager.setHasShadow(true);
        // await windowManager.setSize(Size(800, 600));
        await windowManager.setMinimumSize(const Size(500, 600));
        await windowManager.show();
        await windowManager.focus();
        // if (win) {
          await windowManager.center(animate: true);
        // }
        await windowManager.setPreventClose(true);
        await windowManager.setSkipTaskbar(false);
      });
    }
    control.setMethodHandler();
  }

  @override
  void handleMultiWindow(List<String> args) {
    control.parseWindow(args);
  }

  @override
  void mainEntry(List<String> args) {
    if (args.firstOrNull == 'multi_window') {
      handleMultiWindow(args);
    } else {
      ApplicationType type = ApplicationType(runningMode: currentRunningMode);
      start(type);
    }
  }
}