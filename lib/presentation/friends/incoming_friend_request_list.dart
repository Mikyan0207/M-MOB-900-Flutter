import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/friends_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/friend_request_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/groups/friend_request_list.dart';
import 'package:velocity_x/velocity_x.dart';

class IncomingFriendRequestList extends StatelessWidget {
  IncomingFriendRequestList({super.key});

  final UserController _authController = Get.find();
  final FriendsController _friendsController = Get.find();

  Widget _buildRequestCard(FriendRequestEntity fre) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.black800,
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        fre.fromUser.avatar,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      fre.fromUser.username,
                      style: const TextStyle(
                        color: Vx.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      fre.fromUser.discriminator,
                      style: const TextStyle(
                        color: Vx.gray300,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Vx.red500),
                ),
                onPressed: () async {
                  await _friendsController.declineOrCancelFriendRequest(fre);
                },
                child: const Text(
                  "Decline",
                  style: TextStyle(
                    color: Vx.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Vx.green600),
                  ),
                  onPressed: () async {
                    await _friendsController.acceptFriendRequest(fre);
                  },
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                      color: Vx.white,
                      fontSize: 12,
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FriendRequestList(
        requestStream: FirebaseFirestore.instance
            .collection("FriendRequests")
            .where(
              "ToUser.Id",
              isEqualTo: _authController.currentUser.value.id,
            )
            .snapshots(),
        requestCardBuilder: _buildRequestCard,
      ),
    );
  }
}
