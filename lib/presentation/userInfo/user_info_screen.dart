import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:starlight/presentation/sign_up/sign_up_screen.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../auth/auth_controller.dart';

const darkColor = Color(0xFF49535C);

class AvatarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(8, size.height)
      ..arcToPoint(Offset(114, size.height), radius: Radius.circular(1))
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class userInfoScreen extends StatelessWidget {
  userInfoScreen({super.key});

  final AuthController auth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:
        Material(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Vx.gray800,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          ClipPath(
                            clipper: AvatarClipper(),
                            child: Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                color: darkColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 11,
                            top: 50,
                            child: Row(
                              children: [
                                ProfileWidget(
                                  imagePath: "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png",
                                  onClicked: ()  {},
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Username",
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                        vertical: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.bold),
                                "Username:",
                              ),
                              Text(
                                "Myusername \n\n",
                              ),
                              Text(
                                style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.bold),
                                "Email:",
                              ),
                              Text(
                                "MyEmail \n\n",
                              ),
                              Text(
                                style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.bold),
                                "Password: \n *******",
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 18.0,
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  "Modify",
                                  style: TextStyle(color: Vx.gray100, fontSize: 10),
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 18.0,
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  "Modify",
                                  style: TextStyle(color: Vx.gray100, fontSize: 10),
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 18.0,
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  "Modify",
                                  style: TextStyle(color: Vx.gray100, fontSize: 10),
                                ),
                                onPressed: () {},
                              ),
                            ]
                          )
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
    throw UnimplementedError();
  }
}
class ProfileWidget extends StatelessWidget {

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);
  final String imagePath;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final NetworkImage image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: const Icon(
        Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
