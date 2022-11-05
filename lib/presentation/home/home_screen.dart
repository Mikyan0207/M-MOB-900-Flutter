import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlapping_panels/overlapping_panels.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';
import 'package:starlight/domain/repositories/server_repository.dart';
import 'package:starlight/presentation/chat/chat.dart';
import 'package:starlight/presentation/left/left_panel.dart';
import 'package:starlight/presentation/right/right_panel.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        VxDevice(
          mobile: OverlappingPanels(
            left: Builder(
              builder: (BuildContext context) {
                return LeftPanel();
              },
            ),
            main: Builder(
              builder: (BuildContext context) {
                return Chat();
              },
            ),
            right: Builder(
              builder: (BuildContext context) {
                return const RightPanel();
              },
            ),
          ),
          web: Row(
            children: <Widget>[
              SizedBox(width: 350, child: LeftPanel()),
              Expanded(child: Chat()),
              const SizedBox(width: 275, child: RightPanel()),
            ],
          ),
        ),
      ],
    );
  }
}
