import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/message_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final FlutterParsedTextFieldController flutterParsedTextFieldController =
      FlutterParsedTextFieldController();

  final ChannelController _channelController = Get.find();
  final ServerController _serverController = Get.find();
  final AuthController _authController = Get.find();

  final MessageRepository _messageRepository = MessageRepository();


  late DropzoneViewController controller1;
  String message1 = 'Drop something here';
  bool highlighted1 = false;
  dynamic image;
  late String url;

  @override
  Widget build(BuildContext context) {
    return Container(
            color: highlighted1 ? Colors.red : Colors.transparent,
              child: Stack(
                children: [
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
                                    child:
                                    Stack(
                                      children: [

                                        buildZone1(context),

                                        Form(
                                          key: UniqueKey(),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 150,
                                            ),
                                            child: Obx(
                                                  () => FlutterParsedTextField(
                                                onSubmitted: (String? value) async {
                                                  if (flutterParsedTextFieldController
                                                      .text.isEmptyOrNull) {
                                                    return;
                                                  }

                                                  final String msg =
                                                  flutterParsedTextFieldController
                                                      .stringify()
                                                      .trim();
                                                  flutterParsedTextFieldController.clear();

                                                  await _messageRepository.create(
                                                    MessageEntity(
                                                      author: _authController.currentUser.value,
                                                      content: msg,
                                                      channel: _channelController
                                                          .currentChannel.value,
                                                      time: Timestamp.now(),
                                                    ),
                                                  );
                                                },
                                                suggestionPosition: SuggestionPosition.above,
                                                matchers: <Matcher<dynamic>>[
                                                  Matcher<UserEntity>(
                                                    trigger: "@",
                                                    style: const TextStyle(
                                                      color: AppColors.primaryColor,
                                                    ),
                                                    suggestions: _serverController
                                                        .currentServer.value.members,
                                                    idProp: (dynamic suggestion) =>
                                                    suggestion.id,
                                                    displayProp: (dynamic suggestion) =>
                                                    suggestion.username,
                                                    stringify:
                                                        (String trigger, dynamic suggestion) {
                                                      return '[$trigger${suggestion.username}:${suggestion.id}]';
                                                    },
                                                    parse: (RegExp regex, String suggestion) {
                                                      final RegExpMatch? match =
                                                      regex.firstMatch(suggestion);

                                                      if (match != null) {
                                                        return UserEntity(
                                                          idDocument: match.group(3)!,
                                                          username: match.group(2)!,
                                                        );
                                                      }

                                                      return UserEntity();
                                                    },
                                                    parseRegExp:
                                                    RegExp(r"\[(@([^\]]+)):([^\]]+)\]"),
                                                  ),
                                                ],
                                                textInputAction: TextInputAction.send,
                                                controller: flutterParsedTextFieldController,
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
                                      ],
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
                                        if (flutterParsedTextFieldController
                                            .text.isEmptyOrNull) {
                                          return;
                                        }

                                        final String msg =
                                        flutterParsedTextFieldController
                                            .stringify()
                                            .trim();
                                        flutterParsedTextFieldController.clear();

                                        await _messageRepository.create(
                                          MessageEntity(
                                            author: _authController.currentUser.value,
                                            content: msg,
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
                  //Center(child: Text(message1)),
                ],
              ),
          );
          /*
          ElevatedButton(
            onPressed: () async {
              print(await controller1.pickFiles(mime: ['image/jpeg', 'image/png']));
            },
            child: const Text('Pick file'),
          ),
           */
  }

  Widget buildZone1(BuildContext context) => Builder(
    builder: (BuildContext context) => ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 50,
      ),
        child:
        DropzoneView(
      operation: DragOperation.copy,
      cursor: CursorType.grab,
      onCreated: (DropzoneViewController ctrl) => controller1 = ctrl,
      onLoaded: () => print('Zone 1 loaded'),
      onError: (String? ev) => print('Zone 1 error: $ev'),
      onHover: () {
        setState(() => highlighted1 = true);
        print('Zone 1 hovered');
      },
      onLeave: () {
        setState(() => highlighted1 = false);
        print('Zone 1 left');
      },
      onDrop: (dynamic ev) async {
        print('Zone 1 drop: ${ev.name}');
        final String tempUrl = await controller1.createFileUrl(ev);
        setState(() {
          message1 = '${ev.name} dropped';
          highlighted1 = false;
          url = tempUrl.toString();
        });
        final String extension = ev.name.split('.').last.toString();

        try {
          final Reference ref = FirebaseStorage.instance
              .ref()
              .child('ImageMessage/')
              .child(DateTime.now().toString());
          final SettableMetadata newMetadata = SettableMetadata(
            cacheControl: "public,max-age=300",
            contentType: "image/$extension",
          );

          await ref.putData(await controller1.getFileData(ev), newMetadata);

          await Fluttertoast.showToast(msg: "Image uploaded");
        } catch (e) {
          await Fluttertoast.showToast(msg: e.toString());
        }

        //  final Uint8List bytes = await controller1.getFileData(ev);
      },
    ),
    ),
  );

}
