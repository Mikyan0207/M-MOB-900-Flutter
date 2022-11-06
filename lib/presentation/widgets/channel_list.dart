import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/presentation/widgets/channel_card.dart';

class ChannelList extends StatelessWidget {
  ChannelList({
    Key? key,
  }) : super(key: key);

  final ServerController _serverController = Get.find();
  final ChannelController _channelController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Channels")
            .where(
              "ServerId",
              isEqualTo: _serverController.currentServer.value.id,
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return buildChannelList(
              _serverController.currentServer.value.channels,
            );
          } else {
            return buildChannelListFromMap(parseChannels(snapshot.data!.docs));
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> parseChannels(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<Map<String, dynamic>> channels = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data(),
        )
        .toList();

    return channels;
  }

  ListView buildChannelList(List<ChannelEntity> channels) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: channels.length,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        return ChannelCard(
          isSelected:
              _channelController.currentChannel.value.id == channels[index].id,
          channel: channels[index],
        );
      },
    );
  }

  ListView buildChannelListFromMap(List<Map<String, dynamic>> channels) =>
      buildChannelList(
        channels
            .map((Map<String, dynamic> e) => ChannelEntity.fromJson(e))
            .toList(),
      );
}
