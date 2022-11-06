import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/userInfo/user_info_screen.dart';
import 'package:starlight/presentation/widgets/profile_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileBar extends StatelessWidget {
  ProfileBar({
    Key? key,
  }) : super(key: key);

  final AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.black400,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 50,
              width: 50,
              child: ProfileWidget(
                onClicked: () {
                  Get.to(() => const UserInfoScreen());
                },
                showEdit: false,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5,
              ),
            ),
            Text(
              auth.currentUser?.username ?? "Username",
              style: const TextStyle(color: Vx.gray100, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
