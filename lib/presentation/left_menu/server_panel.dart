import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/channels/channel_list.dart';
import 'package:starlight/presentation/widgets/dialogs/create_channel_dialog.dart';
import 'package:starlight/presentation/widgets/dialogs/invite_friend_to_server_dialog.dart';
import 'package:starlight/presentation/widgets/profile_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class ServerPanel extends GetView<ServerController> {
  const ServerPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Vx.gray800,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.black700,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Obx(
                        () => Container(
                          width: double.infinity,
                          height: 60,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.black900,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    controller.currentServer.value.name,
                                    style: const TextStyle(
                                      color: Vx.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<int>(
                                  color: AppColors.black900,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  offset: const Offset(-195, 55),
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    size: 22,
                                    color: Vx.gray400,
                                  ),
                                  onSelected: (int value) async {
                                    if (value == 0) {
                                      await Get.dialog(
                                        InviteFriendToServerDialog(),
                                        barrierDismissible: true,
                                        barrierColor:
                                            Vx.gray800.withOpacity(0.75),
                                      );
                                    } else if (value == 1) {
                                      await Get.dialog(
                                        CreateChannelDialog(),
                                        barrierDismissible: true,
                                        barrierColor:
                                            Vx.gray800.withOpacity(0.75),
                                      );
                                    } else if (value == 2) {
                                    } else if (value == 3) {
                                      await controller.deleteCurrentServer();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<int>>[
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          children: const <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Invite People",
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50),
                                            Icon(
                                              Icons.group_add_rounded,
                                              color: AppColors.primaryColor,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          children: const <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Create Channel",
                                                style: TextStyle(
                                                  color: Vx.gray200,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50),
                                            Icon(
                                              Icons.add_circle_rounded,
                                              color: Vx.gray400,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          children: const <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Server Settings",
                                                style: TextStyle(
                                                  color: Vx.gray200,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50),
                                            Icon(
                                              Icons.settings_rounded,
                                              color: Vx.gray400,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          children: const <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Delete Server",
                                                style:
                                                    TextStyle(color: Vx.red500),
                                              ),
                                            ),
                                            SizedBox(width: 50),
                                            Icon(
                                              Icons.delete_rounded,
                                              color: Vx.red500,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: ChannelList(),
                      ),
                      ProfileBar()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
