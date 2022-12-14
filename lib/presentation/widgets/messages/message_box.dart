import 'package:any_link_preview/any_link_preview.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/repositories/message_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.showTime,
    required this.showAuthor,
    required this.isMention,
  });

  final MessageEntity message;
  final bool showAvatar;
  final bool showTime;
  final bool showAuthor;
  final bool isMention;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool isHovered = false;
  bool isMessageMenuHovered = false;
  Color hoverBackground = AppColors.black800.withOpacity(0.25);

  final UserController _authController = Get.find();
  final MessageRepository _messageRepository = MessageRepository();

  final RegexOptions options = const RegexOptions();

  Future<void> _deleteMessage() async {
    await _messageRepository.delete(widget.message);
  }

  Color _getBackgroundColor() {
    if (widget.isMention) {
      return AppColors.highlightMessageBackground.withOpacity(0.15);
    }

    if (isHovered || isMessageMenuHovered) {
      return hoverBackground;
    }

    return Colors.transparent;
  }

  BoxBorder _getBoxBorder() {
    if (widget.isMention) {
      return const Border(
        left: BorderSide(
          color: AppColors.highlightMessageBackground,
          width: 1.5,
        ),
      );
    }

    return const Border(
      left: BorderSide(
        color: Colors.transparent,
        width: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: _getBoxBorder(),
        color: _getBackgroundColor(),
      ),
      child: MouseRegion(
        onEnter: (PointerEnterEvent event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (PointerExitEvent event) {
          setState(() {
            isHovered = false;
          });
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.showAvatar ? 6.0 : 1.0,
            left: 10.0,
            bottom: widget.isMention ? 2.0 : 0.0,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              if ((isHovered || isMessageMenuHovered) &&
                  _authController.currentUser.value.id ==
                      widget.message.author.id)
                Positioned(
                  right: 10.0,
                  top: -15.0,
                  child: MouseRegion(
                    onEnter: (PointerEnterEvent event) {
                      setState(() {
                        isMessageMenuHovered = true;
                      });
                    },
                    onExit: (PointerExitEvent event) {
                      setState(() {
                        isMessageMenuHovered = false;
                      });
                    },
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: AppColors.black800),
                        color: AppColors.black700,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Tooltip(
                            message: 'Delete message',
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Vx.red400,
                                size: 16,
                              ),
                              onPressed: () async {
                                await _deleteMessage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: widget.showAvatar
                        ? SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: Ink.image(
                                  image: widget.message.author.avatar
                                          .isNotEmptyAndNotNull
                                      ? NetworkImage(
                                          widget.message.author.avatar,
                                        )
                                      : const NetworkImage(
                                          "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png",
                                        ),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(width: 40),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            if (widget.showAuthor)
                              Text(
                                widget.message.author.username,
                                style: const TextStyle(
                                  color: Vx.red400,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else
                              Container(),
                            if (widget.showTime)
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Timeago(
                                  date: widget.message.time.toDate(),
                                  builder:
                                      (BuildContext context, String value) =>
                                          Text(
                                    value,
                                    style: const TextStyle(
                                      color: Vx.gray400,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(),
                          ],
                        ),
                        Padding(
                          padding: widget.showTime
                              ? const EdgeInsets.only(top: 4.0)
                              : EdgeInsets.zero,
                          child: parseMessage(widget.message.content),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget parseMessage(String content) {
    return ParsedText(
      text: content,
      selectable: true,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 16,
        fontFamily: GoogleFonts.quicksand().fontFamily,
      ),
      parse: <MatchText>[
        // Uploaded images
        MatchText(
          pattern:
              r"(https://firebasestorage.googleapis.com/v0/b/mob-900-flutter.appspot.com/o/)(.*)(\?.*)",
          renderWidget: ({String? pattern, String? text}) {
            if (text == null) {
              return Container();
            }
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.0),
                  child: Image.network(text),
                ),
              ),
            );
          },
        ),
        // Mention
        MatchText(
          pattern: r"\[(@([^\]]+)):([^\]]+)\]",
          renderWidget: ({String? pattern, String? text}) {
            if (text == null) {
              return Container();
            }

            final List<String> userTagParts =
                text.replaceFirst("[", "").replaceFirst("]", "").split(':');

            if (userTagParts.length != 2) {
              return Container();
            }

            return Container(
              decoration: BoxDecoration(
                color: AppColors.mentionBackground.withOpacity(0.95),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3.0,
                  horizontal: 6.0,
                ),
                child: Text(
                  userTagParts[0],
                  style: const TextStyle(
                    color: Vx.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
        // Emotes
        MatchText(
          pattern: r"(<a?)?:\w+:(\d{18}>)?",
          renderWidget: ({String? pattern, String? text}) {
            if (text == null) {
              return Container();
            }

            final Emoji? emoji = Emoji.byShortName(text.replaceAll(":", ""));

            return Text(
              emoji != null ? emoji.toString() : text,
              style: emoji != null
                  ? const TextStyle(fontSize: 24)
                  : const TextStyle(
                      fontSize: 16,
                      color: Vx.white,
                    ),
            );
          },
        ),
        // Links
        MatchText(
          pattern:
              r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)",
          renderWidget: ({String? pattern, String? text}) {
            if (text == null) {
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 450,
                    ),
                    child: AnyLinkPreview(
                      link: text,
                      titleStyle: const TextStyle(
                        color: Vx.white,
                        fontSize: 16,
                      ),
                      bodyStyle: const TextStyle(
                        color: Vx.gray400,
                        fontSize: 12,
                      ),
                      proxyUrl: "https://cryptic-peak-99521.herokuapp.com/",
                      removeElevation: true,
                      cache: const Duration(hours: 1),
                      borderRadius: 7.0,
                      errorWidget: const Center(
                        child: Text(
                          "Oops!",
                          style: TextStyle(color: Vx.red400),
                        ),
                      ),
                      backgroundColor: AppColors.black800,
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
