import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/presentation/widgets/groups/group_card.dart';

class GroupList extends StatelessWidget {
  GroupList({Key? key}) : super(key: key);

  final UserController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Groups")
            .where(
              "Id",
              whereIn: _authController.currentUser.value.groups.isEmpty
                  ? <String>['']
                  : _authController.currentUser.value.groups
                      .map((GroupEntity e) => e.id)
                      .toList(),
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return buildGroupList(parseGroups(snapshot.data!.docs));
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> parseGroups(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<Map<String, dynamic>> groups = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data(),
        )
        .toList();

    return groups;
  }

  ListView buildGroupList(List<Map<String, dynamic>> groups) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      shrinkWrap: true,
      itemCount: groups.length,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        final GroupEntity ge = GroupEntity.fromJson(groups[index]);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: GroupCard(
              group: ge,
            ),
          ),
        );
      },
    );
  }
}
