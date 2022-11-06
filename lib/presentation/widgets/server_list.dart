import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/presentation/widgets/server_icon.dart';

class ServerList extends StatelessWidget {
  ServerList({Key? key}) : super(key: key);

  final String iconPlaceholder =
      "https://static.vecteezy.com/system/resources/previews/007/479/717/original/icon-contacts-suitable-for-mobile-apps-symbol-long-shadow-style-simple-design-editable-design-template-simple-symbol-illustration-vector.jpg";
  final ServerController serverController = Get.find();
  final ChannelController channelController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: serverController.servers
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
      ),
    );
  }
}
