import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/group_controller.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final AuthController _authController = Get.find();
  final GroupController _groupController = Get.find();

  Widget _buildFriendCard(UserEntity ue) {
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
                        ue.avatar,
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
                      ue.username,
                      style: const TextStyle(
                        color: Vx.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ue.discriminator,
                      style: const TextStyle(
                        color: Vx.gray300,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Vx.red500),
                ),
                onPressed: () async {
                  await _groupController.create(
                    GroupEntity(
                      members: <UserEntity>[
                        ue,
                        _authController.currentUser.value,
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Vx.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> _parseFriends(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<dynamic> friends = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data()['Friends'] ?? <dynamic>[],
        )
        .toList();

    return friends.expand((dynamic element) => element).toList();
  }

  ListView _buildFriendsList(List<dynamic> friends) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      shrinkWrap: true,
      itemCount: friends.length,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        final UserEntity ue = UserEntity.fromJson(
          friends[index],
        );

        return _buildFriendCard(ue);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where(
              "Id",
              isEqualTo: _authController.currentUser.value.id,
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return _buildFriendsList(
              _parseFriends(snapshot.data!.docs),
            );
          }
        },
      ),
    );
  }
}
