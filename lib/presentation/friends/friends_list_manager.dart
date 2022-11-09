import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/friends_controller.dart';
import 'package:starlight/presentation/friends/friends_list.dart';
import 'package:starlight/presentation/friends/incoming_friend_request_list.dart';
import 'package:starlight/presentation/friends/pending_friend_request_list.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/add_friend_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendsListManager extends StatelessWidget {
  FriendsListManager({super.key});

  final FriendsController _friendsController = Get.find();

  Widget _getMainView(FriendTabState currentFriendTab) {
    switch (currentFriendTab) {
      case FriendTabState.home:
        return const FriendList();
      case FriendTabState.pending:
        return PendingFriendRequestList();
      case FriendTabState.requests:
        return IncomingFriendRequestList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.black500,
        height: double.infinity,
        width: double.infinity,
        child: Column(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 14.5,
                ),
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: Icon(
                        Icons.star_rounded,
                        color: Vx.gray400,
                        size: 26,
                      ),
                    ),
                    const Text(
                      "Friends",
                      style: TextStyle(
                        color: Vx.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: VerticalDivider(
                        color: Vx.gray400,
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Obx(
                        () => TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                _friendsController.currentTab.value ==
                                        FriendTabState.home
                                    ? MaterialStateProperty.all<Color>(
                                        AppColors.black700.withOpacity(0.75),
                                      )
                                    : MaterialStateProperty.all<Color>(
                                        Colors.transparent,
                                      ),
                          ),
                          onPressed: () {
                            _friendsController.setCurrentTab(
                              FriendTabState.home,
                            );
                          },
                          child: const Text(
                            "All",
                            style: TextStyle(
                              color: Vx.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Obx(
                        () => TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                _friendsController.currentTab.value ==
                                        FriendTabState.pending
                                    ? MaterialStateProperty.all<Color>(
                                        AppColors.black700.withOpacity(0.75),
                                      )
                                    : MaterialStateProperty.all<Color>(
                                        Colors.transparent,
                                      ),
                          ),
                          onPressed: () {
                            _friendsController.setCurrentTab(
                              FriendTabState.pending,
                            );
                          },
                          child: const Text(
                            "Pending",
                            style: TextStyle(
                              color: Vx.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Obx(
                        () => TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                _friendsController.currentTab.value ==
                                        FriendTabState.requests
                                    ? MaterialStateProperty.all<Color>(
                                        AppColors.black700.withOpacity(0.75),
                                      )
                                    : MaterialStateProperty.all<Color>(
                                        Colors.transparent,
                                      ),
                          ),
                          onPressed: () {
                            _friendsController.setCurrentTab(
                              FriendTabState.requests,
                            );
                          },
                          child: const Text(
                            "Requests",
                            style: TextStyle(
                              color: Vx.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Vx.green700),
                        ),
                        onPressed: () async {
                          await Get.dialog(
                            const AddFriendDialog(),
                            barrierDismissible: true,
                            barrierColor: Vx.gray800.withOpacity(0.75),
                          );
                        },
                        child: const Text(
                          "Add Friend",
                          style: TextStyle(
                            color: Vx.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => _getMainView(_friendsController.currentTab.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
