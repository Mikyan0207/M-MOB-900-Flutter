import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/create_server_dialog.dart';
import 'package:starlight/presentation/widgets/server_list.dart';
import 'package:starlight/presentation/widgets/starlight_icon_button.dart';
import 'package:velocity_x/velocity_x.dart';

class LeftMenu extends StatelessWidget {
  LeftMenu({super.key});

  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Vx.gray800,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StarlightIconButton(
                            icon: Icons.star_rounded,
                            iconColor: Vx.gray400,
                            iconHoverColor: Vx.white,
                            backgroundColor: AppColors.black700,
                            backgroundHoverColor: AppColors.primaryColor,
                            onIconClicked: () async {
                              _homeController.setSelectedTab(AppTab.friends);
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Divider(
                            color: Vx.gray600,
                            thickness: 0.5,
                          ),
                        ),
                        Expanded(child: ServerList()),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StarlightIconButton(
                            icon: Icons.add_circle,
                            iconColor: Vx.green600,
                            iconHoverColor: Vx.white,
                            backgroundColor: AppColors.black700,
                            backgroundHoverColor: Vx.green400,
                            onIconClicked: () async {
                              await Get.dialog(
                                const CreateServerDialog(),
                                barrierDismissible: true,
                                barrierColor: Vx.gray800.withOpacity(0.75),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}