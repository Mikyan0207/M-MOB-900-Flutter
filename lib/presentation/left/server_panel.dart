import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/channel_list.dart';
import 'package:starlight/presentation/widgets/create_channel_dialog.dart';
import 'package:starlight/presentation/widgets/profile_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class ServerPanel extends GetView<ServerController> {
  const ServerPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.black700,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      offset: const Offset(-192, 52),
                      icon: const Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 22,
                        color: Vx.gray400,
                      ),
                      onSelected: (int value) {
                        if (value != 1) {
                          return;
                        }

                        Get.dialog<ChannelEntity>(
                          CreateChannelDialog(),
                          barrierDismissible: false,
                          barrierColor: Vx.gray800.withOpacity(0.75),
                        );
                      },
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
          const Expanded(
            child: ChannelList(),
          ),
          ProfileBar()
        ],
      ),
    );
  }
}
