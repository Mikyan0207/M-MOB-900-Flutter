import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({
    Key? key,
    this.imagePath,
    this.status = 'offline',
    required this.onClicked,
    required this.showEdit,
    required this.showStatus,
  }) : super(key: key);

  final String? imagePath;
  final String status;
  final VoidCallback onClicked;
  final bool showEdit;
  final bool showStatus;

  final UserController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    if (showEdit == true) {
      return Obx(
        () => Center(
          child: Stack(
            children: <Widget>[
              _buildImage(),
              Positioned(
                bottom: 0,
                right: 4,
                child: _buildEditIcon(color),
              ),
            ],
          ),
        ),
      );
    } else if (showStatus == true) {
      return Obx(
        () => Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              _buildImage(),
              Positioned(
                bottom: -3,
                right: -3,
                child: _buildStatus(),
              ),
            ],
          ),
        ),
      );
    } else {
      return Obx(
        () => Center(
          child: Stack(
            children: <Widget>[
              _buildImage(),
            ],
          ),
        ),
      );
    }
  }

  String _getImageFromUser() {
    if (imagePath != null) {
      return imagePath as String;
    }
    return auth.currentUser.value.avatar.isEmpty
        ? "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png"
        : auth.currentUser.value.avatar;
  }

  Widget _buildImage() {
    final NetworkImage image = NetworkImage(_getImageFromUser());

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

  Widget _buildStatus() => ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: SizedBox(
          width: 17,
          height: 17,
          child: Container(
            color: AppColors.black800,
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  color: status == "online" ? Vx.green600 : Vx.gray500,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildEditIcon(Color color) => _buildCircle(
        color: Colors.white,
        all: 3,
        child: _buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget _buildCircle({
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
