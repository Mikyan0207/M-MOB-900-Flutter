import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../auth/auth_controller.dart';
import '../themes/theme_colors.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController auth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Vx.gray800,
          width: double.infinity,
          height: double.infinity,
          child: Form(
            key: UniqueKey(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Starlight ✨",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Vx.gray100,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Register now to see what they are talking!",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Vx.gray300,
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 400,
                  child: SvgPicture.asset("assets/undraw_chatting.svg"),
                ),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Vx.gray300,
                        fontWeight: FontWeight.w300,
                      ),
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColors.primaryColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF8667f2), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF8667f2), width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF8667f2), width: 2),
                      ),
                    ),
                    onChanged: (String val) {},

                    // check tha validation
                    validator: (String? val) {
                      return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Vx.gray300,
                          fontWeight: FontWeight.w300,
                        ),
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.primaryColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF8667f2), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF8667f2), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF8667f2), width: 2),
                        ),
                      ),
                      validator: (String? val) {
                        if (val!.length < 6) {
                          return "Password must be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String? val) {},
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Vx.gray300,
                          fontWeight: FontWeight.w300,
                        ),
                        labelText: "Confirm Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.primaryColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF8667f2), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF8667f2), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF8667f2), width: 2),
                        ),
                      ),
                      validator: (String? val) {
                        if (val!.length < 6) {
                          return "Password must be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String? val) {},
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 400,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 24.0,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Vx.gray100, fontSize: 16),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Vx.gray300, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => SignInScreen()),
                        text: "Sign In.",
                        style: const TextStyle(
                          color: Vx.gray100,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
