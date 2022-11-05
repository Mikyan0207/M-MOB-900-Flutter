import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/message_bar.dart';
import 'package:starlight/presentation/widgets/message_box.dart';

class Chat extends StatelessWidget {
  Chat({super.key});

  final ChannelController _channelController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.black500,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Obx(
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
                    snapshot.data!.docs.sort(
                      (
                        QueryDocumentSnapshot<Map<String, dynamic>> a,
                        QueryDocumentSnapshot<Map<String, dynamic>> b,
                      ) =>
                          (b.data()['Time'] as Timestamp).toDate().compareTo(
                                (a.data()['Time'] as Timestamp).toDate(),
                              ),
                    );
                    return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: MessageBox(
                            message: MessageEntity.fromJson(
                              snapshot.data!.docs[index].data(),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      controller: ScrollController(),
                    );
                  }
                },
              ),
            ),
            MessageBar(),
          ],
        ),
      ),
    );
  }
}
