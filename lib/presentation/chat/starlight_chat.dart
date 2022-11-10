import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/private_message_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/message_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/message_bar.dart';
import 'package:starlight/presentation/widgets/private_messages_list.dart';
import 'package:velocity_x/velocity_x.dart';

class StarlightChat extends StatelessWidget {
  StarlightChat({super.key});

  final PrivateMessageController _pmController = Get.find();
  final AuthController _authController = Get.find();

  final MessageRepository _messageRepository = MessageRepository();

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
                        Icons.alternate_email_rounded,
                        color: Vx.gray400,
                        size: 26,
                      ),
                    ),
                    Obx(
                      () => Text(
                        _pmController
                                .currentGroup.value.name.isNotEmptyAndNotNull
                            ? _pmController.currentGroup.value.name
                            : _pmController.currentGroup.value.members
                                .firstWhere(
                                  (UserEntity element) =>
                                      element.id !=
                                      _authController.currentUser.value.id,
                                )
                                .username,
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
                  Expanded(child: PrivateMessagesList()),
                  MessageBar(
                    members: _pmController.currentGroup.value.members,
                    onSendMessage: (String value) async {
                      if (value.isEmptyOrNull) {
                        return;
                      }

                      await _messageRepository.create(
                        MessageEntity(
                          author: _authController.currentUser.value,
                          content: value,
                          group: _pmController.currentGroup.value,
                          time: Timestamp.now(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
