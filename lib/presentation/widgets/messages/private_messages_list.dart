import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/group_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/messages/messages_list.dart';

class PrivateMessagesList extends StatelessWidget {
  PrivateMessagesList({
    Key? key,
  }) : super(key: key);

  final GroupController _groupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MessagesList(
        firestoreStream: FirebaseFirestore.instance
            .collection("Messages")
            .where(
              "Group.Id",
              isEqualTo: _groupController.currentGroup.value.id,
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
