import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/presentation/widgets/server_icon.dart';

class ServerList extends StatelessWidget {
  ServerList({Key? key}) : super(key: key);

  final String iconPlaceholder =
      "https://static.vecteezy.com/system/resources/previews/007/479/717/original/icon-contacts-suitable-for-mobile-apps-symbol-long-shadow-style-simple-design-editable-design-template-simple-symbol-illustration-vector.jpg";

  final AuthController _authController = Get.find();
  final ServerController _serverController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Servers")
            .where(
              "Id",
              whereIn: _authController.currentUserServers.isEmpty
                  ? <String>['']
                  : _authController.currentUserServers,
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return buildServerList(parseServers(snapshot.data!.docs));
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> parseServers(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<Map<String, dynamic>> servers = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data(),
        )
        .toList();

    return servers;
  }

  ListView buildServerList(List<Map<String, dynamic>> servers) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      shrinkWrap: true,
      itemCount: servers.length,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        final ServerEntity se = ServerEntity.fromJson(servers[index]);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: ServerIcon(
              icon: se.icon.isNotEmpty ? se.icon : iconPlaceholder,
              iconSize: 50,
              iconRadius: 25,
              onIconClicked: () async {
                await _serverController.setCurrentServer(se);
              },
            ),
          ),
        );
      },
    );
  }
}
