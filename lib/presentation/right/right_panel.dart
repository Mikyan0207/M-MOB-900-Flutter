import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/presentation/right/role_list.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';

class RightPanel extends StatelessWidget {
  RightPanel({super.key});

  final ServerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ContextMenuOverlay(
          child: Container(
            color: AppColors.black700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.black500,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.black900,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RoleList(roleToShow: "creator"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RoleList(roleToShow: "admin"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RoleList(roleToShow: "member"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
