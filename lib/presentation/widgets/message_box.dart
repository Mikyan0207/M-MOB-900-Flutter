import 'package:flutter/widgets.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          // ignore: todo
          // TODO(Mikyan): avatar ici
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message.author?.username ?? "Unknown",
                style: const TextStyle(color: Vx.gray300, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  message.content!,
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
