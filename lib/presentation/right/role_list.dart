import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/presentation/right/admin_box.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../auth/auth_controller.dart';
import '../../domain/controllers/server_controller.dart';
import '../../domain/entities/user_entity.dart';

class RoleList extends StatelessWidget {
  RoleList({
    Key? key,
    required this.roleToShow,
  }) : super(key: key);

  final AuthController auth = Get.find();

  final String roleToShow;

  final ServerController controller = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("Servers")
                .where(
              "Id",
              isEqualTo: controller.currentServer.value.id,
            )
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "",
                    style: TextStyle(color: AppColors.white),
                  ),
                );
              } else {
                return controller.currentServer.value.id.isEmptyOrNull ? Expanded(child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(),
                    );
                  },
                ),) : Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          roleToShow.upperCamelCase,
                          style: const TextStyle(
                                color: Vx.red400,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                          ),
                        ),
                        buildRoleList(parseRole(snapshot.data!.docs, roleToShow))
                      ],
                    ),
                );
              }
            },
          ),
    );
  }


  List<dynamic> parseRole(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, String roleToShow) {
    final List<dynamic> roleUsers = docs.map((
        QueryDocumentSnapshot<Map<String, dynamic>> e,) =>
    e.data()["Members"],
    ).expand((dynamic element) => element).toList();

    for (int i = 0; i < roleUsers.length; i++) {
      if (roleUsers[i]["Role"] != roleToShow.toString()) {
        roleUsers.removeAt(i);
        i--;
      }
    }

    return roleUsers;
  }

  Expanded buildRoleList(List<dynamic> admins) {
    return admins.isEmpty ? Expanded(child: ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(),
        );
      },
    ),) :
    Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child:
              Column(
                children: <Widget>[
                    AdminBox(
                    adminUser: UserEntity.fromJson(admins[index]),
                  ),

                ],
              )
            );
          },
          itemCount: admins.length,
          controller: _scrollController,
        ),
    );

  }
}