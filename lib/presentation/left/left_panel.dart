import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/presentation/left/server_panel.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/create_server_dialog.dart';
import 'package:starlight/presentation/widgets/server_list.dart';
import 'package:starlight/presentation/widgets/starlight_icon_button.dart';
import 'package:velocity_x/velocity_x.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
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
              const Expanded(
                flex: 3,
                child: ServerPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
