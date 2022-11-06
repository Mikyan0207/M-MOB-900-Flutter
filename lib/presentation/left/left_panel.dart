import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/channel_list.dart';
import 'package:starlight/presentation/widgets/profile_bar.dart';
import 'package:starlight/presentation/widgets/server_list.dart';
import 'package:starlight/presentation/widgets/starlight_icon_button.dart';
import 'package:velocity_x/velocity_x.dart';

class LeftPanel extends StatelessWidget {
  LeftPanel({super.key});

  final ServerController _serverController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Vx.gray800,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(child: ServerList()),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: StarlightIconButton(
                            icon: Icons.add_circle,
                            iconColor: Vx.green600,
                            iconHoverColor: Vx.white,
                            backgroundColor: AppColors.black700,
                            backgroundHoverColor: Vx.green400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
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
                                    _serverController.currentServer.value.name,
                                    style: const TextStyle(
                                      color: Vx.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<int>(
                                  color: AppColors.black900,
                                  offset: const Offset(-192, 52),
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    size: 22,
                                    color: Vx.gray400,
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<int>>[
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: SizedBox(
                                        width: 195,
                                        child: Text(
                                          "Create channel",
                                          style: TextStyle(color: Vx.gray200),
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
                      Expanded(
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
