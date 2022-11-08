import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/private_message_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/message_bar.dart';
import 'package:starlight/presentation/widgets/private_messages_list.dart';
import 'package:velocity_x/velocity_x.dart';

class StarlightChat extends StatelessWidget {
  StarlightChat({super.key});

  final PrivateMessageController _privateMessageController = Get.find();

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
                        _privateMessageController.currentGroup.value.name,
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
                  const MessageBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
