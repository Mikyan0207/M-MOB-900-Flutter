import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/presentation/widgets/channels/channel_card.dart';

class ChannelList extends GetView<ServerController> {
  const ChannelList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Channels")
              .where(
                "Server.Id",
                isEqualTo: controller.currentServer.value.id,
              )
              .snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return buildChannelList(
                controller.currentServer.value.channels,
              );
            } else {
              return buildChannelListFromMap(
                parseChannels(snapshot.data!.docs),
              );
            }
          },
        ),
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
