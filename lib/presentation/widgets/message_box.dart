import 'package:flutter/widgets.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // ignore: todo
        // TODO(Mikyan): avatar ici
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  message.author?.username ?? "Unknown",
                  style: const TextStyle(
                    color: Vx.red400,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (message.time != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Timeago(
                      date: message.time!.toDate(),
                      builder: (BuildContext context, String value) => Text(
                        value,
                        style: const TextStyle(color: Vx.gray400, fontSize: 14),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                message.content!,
                style: const TextStyle(color: AppColors.white, fontSize: 16),
              ),
            )
          ],
        )
      ],
    );
  }
}
