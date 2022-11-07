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
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.black800,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 10.0,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 40,
              width: 40,
              child: ProfileWidget(
                onClicked: () {
                  Get.to(() => const UserInfoScreen());
                },
                showEdit: false,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Obx(
                  () => Text(
                    auth.currentUser.value.username,
                    style: const TextStyle(color: Vx.gray100, fontSize: 14),
                  ),
                ),
                Obx(
                  () => Text(
                    auth.currentUser.value.discriminator,
                    style: const TextStyle(color: Vx.gray400, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
