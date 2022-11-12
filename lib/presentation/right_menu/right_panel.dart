import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/presentation/right_menu/role_list.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class RightPanel extends StatelessWidget {
  RightPanel({super.key});

  final ServerController controller = Get.find();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black900,
      child: SafeArea(
        child: Scaffold(
          body: ContextMenuOverlay(
            child: Container(
              color: AppColors.black700,
              child: Obx(
                () => _homeController.tabSelected.value == AppTab.servers
                    ? Column(
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
                            padding: Vx.isWeb || Vx.isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 8.0)
                                : const EdgeInsets.only(
                                    right: 8.0,
                                    left: 48.0,
                                  ),
                            child: RoleList(roleToShow: "creator"),
                          ),
                          Padding(
                            padding: Vx.isWeb || Vx.isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 8.0)
                                : const EdgeInsets.only(
                                    right: 8.0,
                                    left: 48.0,
                                  ),
                            child: RoleList(roleToShow: "admin"),
                          ),
                          Padding(
                            padding: Vx.isWeb || Vx.isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 8.0)
                                : const EdgeInsets.only(
                                    right: 8.0,
                                    left: 48.0,
                                  ),
                            child: RoleList(roleToShow: "member"),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
