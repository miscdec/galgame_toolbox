import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import '../windows/sample_window.dart';

enum DesktopWindowType {
  sample(0);

  final int value;

  const DesktopWindowType(this.value);

  static DesktopWindowType fromValue(int i) =>
      DesktopWindowType.values.firstWhere((element) => element.value == i);
}

enum DesktopMethodType {
  close(0),
  sendMessage(1);

  final int value;

  const DesktopMethodType(this.value);

  static DesktopMethodType fromValue(int i) =>
      DesktopMethodType.values.firstWhere((element) => element.value == i);

  static DesktopMethodType fromName(String n) => DesktopMethodType.values.firstWhere((element) => element.name == n);
}

abstract class WindowMapper {
  Map get buildMethod;

  Map get buildWindow;
}

class DesktopWindowControl implements WindowMapper {
  /// SET the sub message handler
  void setMethodHandler() {
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      debugPrint('receive child method, ${call.arguments}');
      final type = DesktopMethodType.fromName(call.method);
      buildMethod[type](call, fromWindowId);
    });
  }

  void parseWindow(List<String> args) {
    debugPrint('$args');
    final bundle = jsonDecode(args[2]);
    debugPrint('$bundle -- ${bundle['windowType']}');
    final type = DesktopWindowType.fromValue(bundle['windowType']);

    final instance = buildWindow[type]!;
    runApp(
      MaterialApp(
        home: Scaffold(
          body: instance,
        ),
      ),
    );
    configSubWindow();
  }

  void configSubWindow() {
    // Move place you want.
    windowManager.waitUntilReadyToShow(const WindowOptions(size: Size(400,400)), () async {
      windowManager.show();
      windowManager.center(animate: true);
      windowManager.focus();
    });
  }

  @override
  Map get buildMethod => {
        DesktopMethodType.close: (MethodCall call, int from) async {
          // you can close the window in the main window through the window controller, although you can close it in the sub engine immediately.
          final c = WindowController.fromWindowId(from);
          c.close();
          windowId.remove(from);
        },
        DesktopMethodType.sendMessage: (MethodCall call, int from) async {
          final message = call.arguments;
          messageCallback?.call('from subWindow: $from, $message');
        }
      };

  static Function(String? msg)? messageCallback;

  int wId = 0;
  void showWindow(DesktopWindowType sample) async {
    final c = await DesktopMultiWindow.createWindow(
        jsonEncode({'windowType': sample.value}));
    await c.show();
    wId ++;
    windowId.addAll({
      wId: c
    });
  }

  @override
  Map<DesktopWindowType, Widget> get buildWindow =>
      {DesktopWindowType.sample: const SampleWindow()};

  Map<int, WindowController> windowId = {};

  void notifyChildMessage() {
    for(final i in windowId.keys) {
      DesktopMultiWindow.invokeMethod(i, DesktopMethodType.sendMessage.name, 'Hello Im parent message');
    }
  }
}
