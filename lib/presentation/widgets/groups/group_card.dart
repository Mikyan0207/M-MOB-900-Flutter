import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/group_controller.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class GroupCard extends StatelessWidget {
  GroupCard({
    super.key,
    required this.group,
    this.isSelected = false,
  });

  final GroupEntity group;
  final bool isSelected;

  final GroupController _groupController = Get.find();
  final HomeController _homeController = Get.find();
  final UserController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await _groupController.setCurrentGroup(group.id);
          _homeController.setSelectedTab(AppTab.privateMessage);
        },
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: isSelected ||
                      _groupController.currentGroup.value.id == group.id
                  ? AppColors.black400
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipOval(
                          child: Image.network(
                            group.members
                                .firstWhere(
                                  (UserEntity element) =>
                                      element.id !=
                                      _authController.currentUser.value.id,
                                )
                                .avatar,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      group.name.isNotEmptyAndNotNull
                          ? group.name
                          : group.members
                              .firstWhere(
                                (UserEntity element) =>
                                    element.id !=
                                    _authController.currentUser.value.id,
                              )
                              .username,
                      style: TextStyle(
                        color: isSelected ? Vx.white : Vx.gray300,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
