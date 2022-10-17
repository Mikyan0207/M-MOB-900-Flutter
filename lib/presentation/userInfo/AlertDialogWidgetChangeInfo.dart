import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../themes/theme_colors.dart';
import '../widgets/CustomButton.dart';

Future<void> displayModifyInfoDialog(BuildContext context, String title) async {
  String? valueText;
  String? codeDialog;
  final TextEditingController textFieldController = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (String value) {
                valueText = value;
            },
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Text Field in Dialog"),
          ),
          actions: <Widget>[
            CustomButton(customText: 'Submit', onClicked: () {
                codeDialog = valueText;
                // todo update in firebase data of user
            },
            ),
          ],
        );
      },
  );
}