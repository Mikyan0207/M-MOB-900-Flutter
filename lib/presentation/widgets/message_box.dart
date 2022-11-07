import 'package:flutter/material.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
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
        Column(
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
              padding:
                  showTime ? const EdgeInsets.only(top: 4.0) : EdgeInsets.zero,
              child: Text(
                message.content,
                style: const TextStyle(color: AppColors.white, fontSize: 16),
              ),
            )
          ],
        )
      ],
    );
  }
}
