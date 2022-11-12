import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/presentation/home/home_screen.dart';
import 'package:starlight/presentation/sign_up/sign_up_screen.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final UserController auth = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black900,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            reverse: true,
            controller: ScrollController(),
            child: Container(
              decoration: const BoxDecoration(color: AppColors.black800),
              width: context.screenWidth,
              height: context.screenHeight,
              child: Form(
                key: _key,
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
                        "Login now to see what they are talking!",
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
                      child: Image.asset("assets/undraw_chatting.png"),
                    ),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: AppColors.white),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.black900,
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
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
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
                          controller: passwordController,
                          style: const TextStyle(color: AppColors.white),
                          obscureText: true,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.black900,
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
                              borderSide: BorderSide(
                                color: Color(0xFF8667f2),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF8667f2),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF8667f2),
                                width: 2,
                              ),
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
                          "Sign In",
                          style: TextStyle(color: Vx.gray100, fontSize: 16),
                        ),
                        onPressed: () async {
                          if (await auth.loginAsync(
                            emailController.text,
                            passwordController.text,
                          )) {
                            await Get.to(() => const Home());
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(color: Vx.gray300, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(() => SignUpScreen()),
                            text: "Sign Up.",
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
        ),
      ),
    );
  }
}
