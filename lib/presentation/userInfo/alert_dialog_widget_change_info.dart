import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/presentation/widgets/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

void updateDataUserInFirebase(String field, String value) async {
  final AuthController auth = Get.find();

  // todo check if it's work
  if (field == "password") {
    final User? user = FirebaseAuth.instance.currentUser;
    await user?.updatePassword(value);
  } else {
    if (field == "Email") {
      final User? user = FirebaseAuth.instance.currentUser;
      await user?.updateEmail(value);
    }

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser.value.idDocument)
          .update(<String, Object?>{
        field: value,
      });

      await Fluttertoast.showToast(msg: "$field changed");
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
    }
  }
}

Future<void> displayModifyInfoDialog(
  BuildContext context,
  String title,
  String contentString,
) async {
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
              borderSide: BorderSide(color: Color(0xFF8667f2), width: 2),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8667f2), width: 2),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8667f2), width: 2),
            ),
          ),
        ),
        actions: <Widget>[
          CustomButton(
            customText: 'Submit',
            onClicked: () {
              updateDataUserInFirebase(contentString, textFieldController.text);
              return;
            },
          ),
        ],
      );
    },
  );
}
