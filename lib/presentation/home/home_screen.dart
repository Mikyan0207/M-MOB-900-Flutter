import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlapping_panels/overlapping_panels.dart';
import 'package:starlight/presentation/left/left_panel.dart';
import 'package:starlight/presentation/right/right_panel.dart';
import 'package:velocity_x/velocity_x.dart';

import '../chat/chat.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        VxDevice(
          mobile: OverlappingPanels(
            left: Builder(
              builder: (BuildContext context) {
                return const LeftPanel();
              },
            ),
            main: Builder(
              builder: (BuildContext context) {
                return const Chat();
              },
            ),
            right: Builder(
              builder: (BuildContext context) {
                return const RightPanel();
              },
            ),
          ),
          web: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Expanded(
                  child: LeftPanel(),
                ),
                Expanded(
                  flex: 5,
                  child: Chat(),
                ),
                Expanded(
                  child: RightPanel(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
