import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/custom_button.dart';

void updateDataUserInFirebase(String field, String value) async
{
  // todo if change email and password -> change in firebase authentication
  try
  {
    await FirebaseFirestore.instance.collection('Users').doc("doc").update(<String, Object?>{
      field: value,
    });

    await Fluttertoast.showToast(msg: "$field changed");
  }
  catch(e)
  {
    await Fluttertoast.showToast(msg: e.toString());
  }
}

Future<void> displayModifyInfoDialog(BuildContext context, String title, String contentString) async {
  final TextEditingController textFieldController = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              labelStyle: const TextStyle(
                color: Vx.gray300,
                fontWeight: FontWeight.w300,
              ),
              labelText: contentString,
              focusedBorder: const OutlineInputBorder(
                borderSide:
                BorderSide(color: Color(0xFF8667f2), width: 2),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                BorderSide(color: Color(0xFF8667f2), width: 2),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide:
                BorderSide(color: Color(0xFF8667f2), width: 2),
              ),
            ),
          ),
          actions: <Widget>[
            CustomButton(customText: 'Submit', onClicked: () {
                updateDataUserInFirebase(contentString, textFieldController.text);
                return;
            },
            ),
          ],
        );
      },
  );
}