import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlapping_panels/overlapping_panels.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/presentation/chat/chat.dart';
import 'package:starlight/presentation/left/left_panel.dart';
import 'package:starlight/presentation/right/right_panel.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero, () async {
      if (_authController.currentUser.value.id.isEmpty) {
        await Get.to(() => SignInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VxDevice(
      mobile: Stack(
        children: <Widget>[
          OverlappingPanels(
            left: Builder(
              builder: (BuildContext context) {
                return const LeftPanel();
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
        ],
      ),
      web: Row(
        children: <Widget>[
          const SizedBox(width: 350, child: LeftPanel()),
          Expanded(flex: 2, child: Chat()),
          const SizedBox(width: 275, child: RightPanel()),
        ],
      ),
    );
  }
}
