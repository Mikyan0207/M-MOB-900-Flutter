import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/repositories/server_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/userInfo/user_info_screen.dart';
import 'package:starlight/presentation/widgets/profile_widget.dart';
import 'package:starlight/presentation/widgets/server_icon.dart';
import 'package:starlight/presentation/widgets/starlight_icon_button.dart';
import 'package:velocity_x/velocity_x.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  final ServerRepository serverRepository = ServerRepository();
  final AuthController auth = Get.put(AuthController());

  final String iconPlaceholder =
      "https://static.vecteezy.com/system/resources/previews/007/479/717/original/icon-contacts-suitable-for-mobile-apps-symbol-long-shadow-style-simple-design-editable-design-template-simple-symbol-illustration-vector.jpg";

  late List<ServerEntity>? _servers = <ServerEntity>[];

  @override
  void initState() {
    _servers = auth.currentUser?.servers;

    _servers ??= <ServerEntity>[];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Vx.gray800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child:
                  Column(
                    children: <Widget>[
                      loadServerIcons(_servers),
                      const SizedBox(
                        height: 10,
                      ),
                      const StarlightIconButton(
                        icon: Icons.add_circle,
                        iconColor: Vx.green600,
                        iconHoverColor: Vx.white,
                        backgroundColor: AppColors.black700,
                        backgroundHoverColor: Vx.green400,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileWidget(
                        imagePath: "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png",
                        onClicked: ()  {
                          Get.to(() => const UserInfoScreen());
                        },
                        showEdit: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.black700,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadServerIcons(List<ServerEntity>? servers) {

    if (servers == null) {
      return Container();
    }

    return Row(
      children: servers
          .map(
            (ServerEntity item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ServerIcon(
                icon: iconPlaceholder,
                iconSize: 50,
                iconRadius: 25,
              ),
            ),
          )
          .toList(),
    );
  }
}
