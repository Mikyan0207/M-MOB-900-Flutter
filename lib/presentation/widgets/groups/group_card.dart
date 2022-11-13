import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/group_controller.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class GroupCard extends StatefulWidget {
  const GroupCard({
    super.key,
    required this.group,
    this.isSelected = false,
  });

  final GroupEntity group;
  final bool isSelected;

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard>
    with SingleTickerProviderStateMixin {
  final GroupController _groupController = Get.find();
  final HomeController _homeController = Get.find();
  final UserController _authController = Get.find();

  late final AnimationController backgroundColorController;
  late final Animation<Color?> backgroundColorAnimation;

  late final UserEntity otherUser;

  @override
  void initState() {
    super.initState();

    otherUser = widget.group.members.firstWhere(
      (UserEntity element) =>
          element.id != _authController.currentUser.value.id,
    );

    backgroundColorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    )..addListener(() {
        // Marks the widget tree as dirty
        setState(() {});
      });

    backgroundColorAnimation = ColorTween(
      begin: AppColors.black700,
      end: AppColors.black400,
    ).animate(backgroundColorController);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (PointerEnterEvent event) {
        if (widget.isSelected ||
            _groupController.currentGroup.value.id == widget.group.id) {
          return;
        }

        backgroundColorController.forward();
      },
      onExit: (PointerExitEvent event) {
        if (widget.isSelected ||
            _groupController.currentGroup.value.id == widget.group.id) {
          return;
        }

        backgroundColorController.reverse();
      },
      child: GestureDetector(
        onTap: () async {
          await _groupController.setCurrentGroup(widget.group.id);
          _homeController.setSelectedTab(AppTab.privateMessage);
        },
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: widget.isSelected ||
                      _groupController.currentGroup.value.id == widget.group.id
                  ? AppColors.black400
                  : backgroundColorAnimation.value,
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipOval(
                            child: Image.network(
                              otherUser.avatar,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: ClipRRect(
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
                                    color: otherUser.status == "online"
                                        ? Vx.green600
                                        : Vx.gray500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            otherUser.username,
                            style: TextStyle(
                              color: Vx.white,
                              fontSize: 16,
                              fontWeight: widget.isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            otherUser.discriminator,
                            style: TextStyle(
                              color: Vx.gray300,
                              fontSize: 12,
                              fontWeight: widget.isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
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
