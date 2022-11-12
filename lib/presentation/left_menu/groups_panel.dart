import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/friends_controller.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/dialogs/create_group_dialog.dart';
import 'package:starlight/presentation/widgets/groups/group_list.dart';
import 'package:starlight/presentation/widgets/profile_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class StarlightFriendsList extends GetView<FriendsController> {
  const StarlightFriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black900,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              color: AppColors.black900,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.black700,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.black900,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "PRIVATE MESSAGES",
                            style: TextStyle(
                              color: Vx.gray400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Get.dialog(
                                const CreateGroupDialog(),
                                barrierDismissible: true,
                                barrierColor: Vx.gray800.withOpacity(0.75),
                              );
                            },
                            icon: const Icon(
                              Icons.add_rounded,
                              size: 22,
                              color: Vx.gray300,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: GroupList()),
                    ProfileBar(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
