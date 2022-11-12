import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlapping_panels/overlapping_panels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/repositories/server_repository.dart';
import 'package:starlight/presentation/chat/server_chat.dart';
import 'package:starlight/presentation/chat/starlight_chat.dart';
import 'package:starlight/presentation/friends/friends_list_manager.dart';
import 'package:starlight/presentation/left/groups_panel.dart';
import 'package:starlight/presentation/left/left_menu.dart';
import 'package:starlight/presentation/left/server_panel.dart';
import 'package:starlight/presentation/right/right_panel.dart';
import 'package:starlight/presentation/splash/splash_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../domain/entities/user_entity.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final AuthController _authController = Get.find();
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
        await _authController.retrieveUserFromId(userId!);
      }

      final String? lastServerId = prefs.getString("LastServerId");

      if (lastServerId != null) {
        await _serverController.setCurrentServer(
          await _serverController.getFromId(lastServerId),
        );

        _homeController.setSelectedTab(AppTab.servers);

        final String? lastChannelId = prefs.getString("LastChannelId");

        if (lastChannelId != null) {
          _channelController.setCurrentChannel(
            await _channelController.getFromId(lastChannelId),
          );
        }
        _homeController.setSelectedTab(AppTab.servers);
      }
    });
  }

  @override
  void deactivate()
  {
    print("deactivate");
    super.deactivate();
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
