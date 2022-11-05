import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../auth/auth_controller.dart';

class ProfileWidget extends StatelessWidget {

  ProfileWidget({
    Key? key,
    this.imagePath,
    required this.onClicked,
    required this.showEdit,
  }) : super(key: key);
  String? imagePath;
  final VoidCallback onClicked;
  final bool showEdit;

  final AuthController auth = Get.put(AuthController());

  String getImageFromUser()
  {
    if (imagePath != null)
    {
      return imagePath as String;
    }
    return auth.currentUser?.avatar?? "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png";
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;


    if (showEdit == true)
    {
      return Center(
        child: Stack(
          children: <Widget> [
            buildImage(),
            Positioned(
              bottom: 0,
              right: 4,
              child: buildEditIcon(color),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Stack(
          children: <Widget> [
            buildImage(),
          ],
        ),
      );
    }
  }

  Widget buildImage() {
    final NetworkImage image = NetworkImage(getImageFromUser());

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
