import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/presentation/right/admin_box.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';

import '../../auth/auth_controller.dart';
import '../../domain/controllers/server_controller.dart';
import '../../domain/entities/user_entity.dart';

class AdminList extends StatelessWidget {
  AdminList({
    Key? key,
  }) : super(key: key);

  final AuthController auth = Get.find();

  final ServerController controller = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Servers")
            .where(
              "Id",
              isEqualTo: controller.currentServer.value.id,
        )
            .snapshots(),
        builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No Admin in this group",
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else {
            return buildAdminList(parseAdmin(snapshot.data!.docs));
          }
        },
      ),
    );
  }


  List<dynamic> parseAdmin(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs)
  {
    final List<dynamic> admins = docs.map((
        QueryDocumentSnapshot<Map<String, dynamic>> e,) =>
            e.data()["Admin"],
        ).expand((dynamic element) => element).toList();

    return admins;
  }


  ListView buildAdminList(List<dynamic> admins) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: AdminBox(
              adminUser: UserEntity.fromJson(admins[index]),
          ),
        );
      },
      shrinkWrap: true,
      controller: _scrollController,
    );
  }
}
