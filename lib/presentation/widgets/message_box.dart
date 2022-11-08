import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.showTime,
    required this.showAuthor,
  });

  final MessageEntity message;
  final bool showAvatar;
  final bool showTime;
  final bool showAuthor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: showAvatar
              ? SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: message.author.avatar.isNotEmptyAndNotNull
                            ? NetworkImage(message.author.avatar)
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
                  if (showAuthor)
                    Text(
                      message.author.username,
                      style: const TextStyle(
                        color: Vx.red400,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Container(),
                  if (showTime)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Timeago(
                        date: message.time.toDate(),
                        builder: (BuildContext context, String value) => Text(
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
                padding: showTime
                    ? const EdgeInsets.only(top: 4.0)
                    : EdgeInsets.zero,
                child: parseMessage(message.content),
              )
            ],
          ),
        )
      ],
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
        MatchText(
          pattern:
              r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)",
          renderWidget: ({String? pattern, String? text}) {
            if (text == null) {
              return Container();
            }
            print(content == text);

            return Padding(
              padding: content == text
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(top: 12.0),
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
                      cache: const Duration(hours: 12),
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
