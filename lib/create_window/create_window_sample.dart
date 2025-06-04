import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:galgame_toolbox/window_communicate/window_communicate_sample.dart';
import 'package:window_manager/window_manager.dart';

import '../application.dart';

class CreateWindowSample extends StatefulWidget {
  const CreateWindowSample({super.key});

  @override
  State<StatefulWidget> createState() => _CreateWindowSampleState();
}

class _CreateWindowSampleState extends State<CreateWindowSample>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    DesktopWindowControl.messageCallback = (String? m) {
      if (m == null) return;
      setState(() {
        if (data.length > 10) {
          data.removeAt(0);
        }
        data.add(m);
      });
    };
    super.initState();
  }

  @override
  void onWindowFocus() {
    debugPrint('window focus');
    super.onWindowFocus();
  }

  @override
  void onWindowClose() {
    debugPrint('window start true close');
    windowManager.destroy();
    super.onWindowClose();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  control.showWindow(DesktopWindowType.sample);
                },
                child: Container(
                  height: 40,
                  color: Colors.amber,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Create New Window!'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  control.notifyChildMessage();
                },
                child: Container(
                  height: 40,
                  color: Colors.amber,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Send message to child Window!'),
                    ],
                  ),
                ),
              ),
              Column(
                children: itemBuilder(context),
              )
            ],
          )
        ],
      ),
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
