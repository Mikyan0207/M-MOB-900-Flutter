import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/presentation/widgets/servers/server_icon.dart';

class ServerList extends StatelessWidget {
  ServerList({Key? key}) : super(key: key);

  final UserController _authController = Get.find();
  final ServerController _serverController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Servers")
            .where(
              "Id",
              whereIn: _authController.currentUser.value.servers.isEmpty
                  ? <String>['']
                  : _authController.currentUser.value.servers
                      .map((ServerEntity e) => e.id)
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
        final ServerEntity se = ServerEntity.fromJson(
          servers[index],
          options: const ServerQueryOptions(includeMembers: true),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: ServerIcon(
              icon: se.icon,
              iconSize: 50,
              iconRadius: 25,
              serverId: se.id,
              onIconClicked: () async {
                await _serverController.setCurrentServer(se.id);
                _homeController.setSelectedTab(AppTab.servers);
              },
            ),
          ),
        );
      },
    );
  }
}
