import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import '../../domain/controllers/server_controller.dart';
import 'role_list.dart';

class RightPanel extends StatelessWidget {
  RightPanel({super.key});

  final ServerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ContextMenuOverlay(
      child: Container(
        color: AppColors.black700,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RoleList(roleToShow: "creator"),
              RoleList(roleToShow: "admin"),
              RoleList(roleToShow: "member"),
            ],
          ),
        ),
      ),
    );
  }
}
