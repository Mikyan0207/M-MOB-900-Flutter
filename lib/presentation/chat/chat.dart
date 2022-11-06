import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/messages_list.dart';
import 'package:starlight/presentation/widgets/message_bar.dart';
import 'package:starlight/presentation/widgets/message_box.dart';
import 'package:velocity_x/velocity_x.dart';

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
          children: <Widget>[
            Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 14.5,
                ),
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: Icon(
                        Icons.numbers_rounded,
                        color: Vx.gray400,
                        size: 26,
                      ),
                    ),
                    Obx(
                      () => Text(
                        _channelController.currentChannel.value.name
                            .toLowerCase(),
                        style: const TextStyle(
                          color: Vx.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: MessagesList()),
                  MessageBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
