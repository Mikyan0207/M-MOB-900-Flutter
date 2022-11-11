import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/presentation/home/home_screen.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future<void>.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String? userId = prefs.getString("UserId");

      if (userId.isEmptyOrNull) {
        await Get.to(() => SignInScreen());
      } else {
        final UserController authController = Get.find();

        await authController.retrieveUserFromId(userId!);
        await Get.to(() => const Home());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.black800,
          ),
          child: const Center(
            child: Text(
              "Starlight ✨",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Vx.gray100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
