import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/message_box.dart';

class MessagesList extends StatelessWidget {
  MessagesList({
    Key? key,
  }) : super(key: key);

  final ChannelController _channelController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .where(
              "ChannelId",
              isEqualTo: _channelController.currentChannel.value.id,
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No Messages",
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else {
            return buildChannelList(parseMessages(snapshot.data!.docs));
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> parseMessages(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<Map<String, dynamic>> messages = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data(),
        )
        .toList();

    messages.sort((
      Map<String, dynamic> a,
      Map<String, dynamic> b,
    ) {
      return (b['Time'] as Timestamp).compareTo(a['Time'] as Timestamp);
    });

    return messages;
  }

  ListView buildChannelList(List<Map<String, dynamic>> messages) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: MessageBox(
            message: MessageEntity.fromJson(
              messages[index],
            ),
          ),
        );
      },
      itemCount: messages.length,
      shrinkWrap: true,
      reverse: true,
      controller: _scrollController,
    );
  }
}
