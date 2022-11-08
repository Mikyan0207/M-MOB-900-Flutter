import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/repositories/message_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final TextEditingController textarea = TextEditingController();

  final ChannelController _channelController = Get.find();

  final MessageRepository _messageRepository = MessageRepository();

  final AuthController _authController = Get.find();

  final FocusNode _focusNode = FocusNode();

  bool wasShiftPressed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 25,
              maxHeight: 150,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.black400,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Vx.gray400,
                        ),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: Form(
                          key: UniqueKey(),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 150,
                            ),
                            child: Obx(
                              () => RawKeyboardListener(
                                focusNode: _focusNode,
                                onKey: (RawKeyEvent value) async {
                                  if (!value.isShiftPressed &&
                                      value.isKeyPressed(
                                        LogicalKeyboardKey.enter,
                                      )) {
                                    await _messageRepository.create(
                                      MessageEntity(
                                        author:
                                            _authController.currentUser.value,
                                        content: textarea.text.trim(),
                                        channel: _channelController
                                            .currentChannel.value,
                                        time: Timestamp.now(),
                                      ),
                                    );

                                    textarea.text = '';
                                  }
                                },
                                child: TextFormField(
                                  textInputAction: TextInputAction.none,
                                  controller: textarea,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(
                                    color: Vx.gray100,
                                  ),
                                  cursorColor: Vx.gray400,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Vx.gray500,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .fontSize,
                                    ),
                                    hintText:
                                        'Message #${_channelController.currentChannel.value.name.toLowerCase()}',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.sticky_note_2,
                              color: Vx.gray300,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Vx.gray300,
                            ),
                            onPressed: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: VerticalDivider(
                              thickness: context.isMobile ? 1 : 0.5,
                              color: Vx.gray400,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Vx.indigo300,
                            ),
                            onPressed: () async {
                              if (textarea.text.isEmptyOrNull) {
                                return;
                              }

                              await _messageRepository.create(
                                MessageEntity(
                                  author: _authController.currentUser.value,
                                  content: textarea.text,
                                  channel:
                                      _channelController.currentChannel.value,
                                  time: Timestamp.now(),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
