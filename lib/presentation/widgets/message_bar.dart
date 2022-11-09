import 'package:flutter/material.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({
    super.key,
    required this.onSendMessage,
    required this.members,
  });

  final Future<void> Function(
    String value,
  ) onSendMessage;

  final List<UserEntity> members;

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final FlutterParsedTextFieldController flutterParsedTextFieldController =
      FlutterParsedTextFieldController();

  final ChannelController _channelController = Get.find();
  final FocusNode _textFieldNode = FocusNode();

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
                              () => FlutterParsedTextField(
                                focusNode: _textFieldNode,
                                autofocus: true,
                                onSubmitted: (String? value) async {
                                  final String content =
                                      flutterParsedTextFieldController
                                          .stringify()
                                          .trim();

                                  flutterParsedTextFieldController.clear();
                                  await widget.onSendMessage.call(content);
                                  _textFieldNode.unfocus();
                                  _textFieldNode.requestFocus();
                                },
                                suggestionPosition: SuggestionPosition.above,
                                matchers: <Matcher<dynamic>>[
                                  Matcher<UserEntity>(
                                    trigger: "@",
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                    ),
                                    suggestions: widget.members,
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
                                          id: match.group(3)!,
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
                              final String content =
                                  flutterParsedTextFieldController
                                      .stringify()
                                      .trim();

                              flutterParsedTextFieldController.clear();
                              await widget.onSendMessage.call(content);
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
