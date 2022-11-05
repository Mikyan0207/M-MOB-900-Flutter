import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/server_icon.dart';
import 'package:starlight/presentation/widgets/starlight_icon_button.dart';
import 'package:velocity_x/velocity_x.dart';

class LeftPanel extends StatelessWidget {
  LeftPanel({super.key});

  final AuthController auth = Get.find();
  final ServerController serverController = Get.find();
  final ChannelController channelController = Get.find();

  final String iconPlaceholder =
      "https://static.vecteezy.com/system/resources/previews/007/479/717/original/icon-contacts-suitable-for-mobile-apps-symbol-long-shadow-style-simple-design-editable-design-template-simple-symbol-illustration-vector.jpg";

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      Get.toNamed("SignInScreen");
    }

    serverController.setServersFromUser(auth.currentUser!);

    return Container(
      width: double.infinity,
      color: Vx.gray800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    children: <Widget>[
                      loadServerIcons(serverController.servers),
                      const SizedBox(
                        height: 10,
                      ),
                      const StarlightIconButton(
                        icon: Icons.add_circle,
                        iconColor: Vx.green600,
                        iconHoverColor: Vx.white,
                        backgroundColor: AppColors.black700,
                        backgroundHoverColor: Vx.green400,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.black700,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
              ),
              child: Column(
                children: <Widget>[
                  Obx(() => loadChannels(serverController.channels)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadChannels(List<ChannelEntity>? channels) {
    if (channels == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: channels
          .map(
            (ChannelEntity item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: serverController.currentChannel.value.id == item.id
                  ? Container(
                      color: Vx.gray500,
                      child: Text(
                        item.id,
                        style: const TextStyle(color: Vx.white),
                      ),
                    )
                  : TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Vx.red300),
                      ),
                      onPressed: () {
                        channelController.setCurrentChannel(item);
                      },
                      child: Text(
                        item.id,
                        style: const TextStyle(color: Vx.white),
                      ),
                    ),
            ),
          )
          .toList(),
    );
  }

  Widget loadServerIcons(List<ServerEntity>? servers) {
    if (servers == null) {
      return Container();
    }

    return Column(
      children: servers
          .map(
            (ServerEntity item) => Center(
              child: ServerIcon(
                icon: iconPlaceholder,
                iconSize: 50,
                iconRadius: 25,
                onIconClicked: () async {
                  serverController.setCurrentServer(item);
                  await serverController.getChannelsForCurrentServer();
                  if (serverController.channels.isNotEmpty) {
                    channelController.setCurrentChannel(
                      serverController.channels[0],
                    );
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
