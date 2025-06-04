import 'package:collection/collection.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../window_communicate/window_communicate_sample.dart';

class SampleWindow extends StatefulWidget {
  const SampleWindow({super.key});

  @override
  State<StatefulWidget> createState() => _SampleWindowState();
}

class _SampleWindowState extends State<SampleWindow> {
  
  Map get buildMethodMap => {
    DesktopMethodType.sendMessage: (MethodCall call, int from) async {
      final m = 'from parent: $from - ${call.arguments}';
      setState(() {
        if (data.length > 10) {
          data.removeAt(0);
        }
        data.add(m);
      });
    }
  };
  
  @override
  void initState() {
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      final type = DesktopMethodType.fromName(call.method);
      buildMethodMap[type](call, fromWindowId);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              color: Colors.amber,
              child: InkWell(
                onTap: () {
                  DesktopMultiWindow.invokeMethod(
                      0, DesktopMethodType.sendMessage.name, "Hello!");
                },
                child: const Text('SendMessage'),
              ),
            ),
            Container(
              height: 40,
              color: Colors.amber,
              child: InkWell(
                onTap: () {
                  DesktopMultiWindow.invokeMethod(
                      0, DesktopMethodType.close.name);
                },
                child: const Text('CloseWindow'),
              ),
            ),
            Column(
              children: itemBuilder(context),
            )
          ],
        )
      ],
    );
  }

  List<String> data = [];

  List<Widget> itemBuilder(BuildContext context) {
    return data
        .mapIndexed(
          (i, v) => Opacity(
        opacity: 1.0 - (10 - i) / 10,
        child: Text(v),
      ),
    )
        .toList();
  }
}
