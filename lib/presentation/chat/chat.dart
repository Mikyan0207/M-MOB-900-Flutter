import 'package:flutter/material.dart';
import 'package:starlight/presentation/widgets/message_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Vx.gray700,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MessageBar(),
          ],
        ),
      ),
    );
  }
}