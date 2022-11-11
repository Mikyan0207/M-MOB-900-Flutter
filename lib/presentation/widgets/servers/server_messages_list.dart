import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/messages/messages_list.dart';

class ServerMessagesList extends StatelessWidget {
  ServerMessagesList({
    Key? key,
  }) : super(key: key);

  final ChannelController _channelController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MessagesList(
        firestoreStream: FirebaseFirestore.instance
            .collection("Messages")
            .where(
              "Channel.Id",
              isEqualTo: _channelController.currentChannel.value.id,
            )
            .snapshots(),
        noDataWidget: const Center(
          child: Text(
            "No Messages",
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
