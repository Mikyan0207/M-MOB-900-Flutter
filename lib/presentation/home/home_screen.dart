import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlapping_panels/overlapping_panels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/presentation/chats/server_chat.dart';
import 'package:starlight/presentation/chats/starlight_chat.dart';
import 'package:starlight/presentation/friends/friends_list_manager.dart';
import 'package:starlight/presentation/left_menu/groups_panel.dart';
import 'package:starlight/presentation/left_menu/left_menu.dart';
import 'package:starlight/presentation/left_menu/server_panel.dart';
import 'package:starlight/presentation/right_menu/right_panel.dart';
import 'package:starlight/presentation/splash/splash_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  final ServerController _serverController = Get.find();
  final ChannelController _channelController = Get.find();

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String? userId = prefs.getString("UserId");

      if (userId.isEmptyOrNull) {
        await Get.to(() => const SplashScreen());
      } else {
        await _userController.setCurrentUser(userId!);
        //await setStatus("online");
      }

      final String? lastServerId = prefs.getString("LastServerId");

      if (lastServerId != null) {
        await _serverController.setCurrentServer(lastServerId);

        _homeController.setSelectedTab(AppTab.servers);

        final String? lastChannelId = prefs.getString("LastChannelId");

        if (lastChannelId != null) {
          _channelController.setCurrentChannel(
            await _channelController.getFromId(lastChannelId),
          );
        }
        _homeController.setSelectedTab(AppTab.servers);
      } else {
        _homeController.setSelectedTab(AppTab.friends);
      }
    });
  }

  Widget _displayCorrespondingView(AppTab currentTab) {
    switch (currentTab) {
      case AppTab.none:
        return Container();
      case AppTab.servers:
        return Expanded(child: ServerChat());
      case AppTab.friends:
        return Expanded(child: FriendsListManager());
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
                  children: const <Widget>[
                    SizedBox(width: 75, child: LeftMenu()),
                    Expanded(flex: 3, child: ServerPanel()),
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
                    const SizedBox(width: 75, child: LeftMenu()),
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
            Obx(
              () => _homeController.tabSelected.value == AppTab.servers
                  ? SizedBox(width: 275, child: RightPanel())
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
