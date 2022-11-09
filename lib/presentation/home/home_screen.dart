import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlapping_panels/overlapping_panels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/presentation/chat/server_chat.dart';
import 'package:starlight/presentation/chat/starlight_chat.dart';
import 'package:starlight/presentation/left/left_menu.dart';
import 'package:starlight/presentation/left/server_panel.dart';
import 'package:starlight/presentation/right/right_panel.dart';
import 'package:starlight/presentation/splash/splash_screen.dart';
import 'package:starlight/presentation/starlight/friends_list_manager.dart';
import 'package:starlight/presentation/starlight/starlight_friends_list.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthController _authController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String? userId = prefs.getString("UserId");

      if (userId.isEmptyOrNull) {
        await Get.to(() => const SplashScreen());
      } else {
        await _authController.retrieveUserFromId(userId!);
      }
    });
  }

  Widget _displayCorrespondingView(AppTab currentTab) {
    switch (currentTab) {
      case AppTab.servers:
        return Expanded(child: ServerChat());
      case AppTab.friends:
        return const Expanded(child: FriendsListManager());
      case AppTab.privateMessage:
        return Expanded(child: StarlightChat());
    }
  }

  @override
  Widget build(BuildContext context) {
    return VxDevice(
      mobile: Stack(
        children: <Widget>[
          OverlappingPanels(
            left: Builder(
              builder: (BuildContext context) {
                return Row(
                  children: <Widget>[
                    SizedBox(width: 75, child: LeftMenu()),
                    const Expanded(flex: 3, child: ServerPanel()),
                  ],
                );
              },
            ),
            main: Builder(
              builder: (BuildContext context) {
                return ServerChat();
              },
            ),
            right: Builder(
              builder: (BuildContext context) {
                return RightPanel();
              },
            ),
          ),
        ],
      ),
      web: Container(
        width: double.infinity,
        height: double.infinity,
        color: Vx.gray800,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 350,
              child: Obx(
                () => Row(
                  children: <Widget>[
                    SizedBox(width: 75, child: LeftMenu()),
                    if (_homeController.tabSelected.value != AppTab.servers)
                      const Expanded(child: StarlightFriendsList())
                    else
                      const Expanded(child: ServerPanel()),
                  ],
                ),
              ),
            ),
            Obx(
              () =>
                  _displayCorrespondingView(_homeController.tabSelected.value),
            ),
            SizedBox(width: 275, child: RightPanel()),
          ],
        ),
      ),
    );
  }
}
