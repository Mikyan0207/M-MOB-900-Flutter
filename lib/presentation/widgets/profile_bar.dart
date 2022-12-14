import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/group_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/splash/splash_screen.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/user_info/user_info_screen.dart';
import 'package:starlight/presentation/widgets/profile_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileBar extends StatelessWidget {
  ProfileBar({
    Key? key,
  }) : super(key: key);

  final UserController _userController = Get.find();

  Future<void> setStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_userController.currentUser.value.id)
        .update(<String, Object?>{
      'Status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.black800,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 10.0,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 40,
              width: 40,
              child: Obx(
                () => ProfileWidget(
                  onClicked: () {
                    Get.to(() => const UserInfoScreen());
                  },
                  showEdit: false,
                  showStatus: true,
                  status: _userController.currentUser.value.status,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Obx(
                    () => Text(
                      _userController.currentUser.value.username,
                      style: const TextStyle(
                        color: Vx.gray100,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      _userController.currentUser.value.discriminator,
                      style: const TextStyle(
                        color: Vx.gray400,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: Vx.isWeb || Vx.isDesktop
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(
                      right: 22.0,
                    ),
              child: PopupMenuButton<int>(
                color: AppColors.black900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                offset: const Offset(-125, -75),
                icon: const Icon(
                  Icons.settings_rounded,
                  size: 24.0,
                  color: Vx.gray400,
                ),
                onSelected: (int value) async {
                  if (value != 0) {
                    return;
                  }

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await setStatus("offline");
                  await prefs.remove("UserId");
                  await prefs.remove("LastServerId");
                  await FirebaseAuth.instance.signOut();
                  Get.find<UserController>().currentUser.value = UserEntity();
                  Get.find<ServerController>().currentServer.value =
                      ServerEntity();
                  Get.find<ChannelController>().currentChannel.value =
                      ChannelEntity();
                  Get.find<GroupController>().currentGroup.value =
                      GroupEntity();
                  await Get.to(() => const SplashScreen());
                },
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "Sign out",
                              style: TextStyle(
                                color: Vx.red400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 50),
                          Icon(
                            Icons.logout_rounded,
                            color: Vx.red400,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
