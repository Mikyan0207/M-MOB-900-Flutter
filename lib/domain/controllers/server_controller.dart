import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/server_repository.dart';

class ServerController extends GetxController {
  Rx<ServerEntity> currentServer = ServerEntity().obs;

  final ServerRepository serverRepository = ServerRepository();
  final ChannelController _channelController = Get.find();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? listener;

  Future<void> deleteCurrentServer() async {
    await serverRepository.delete(currentServer.value);
  }

  Future<void> joinServer(UserEntity newUser) async {
    await serverRepository.joinServer(currentServer.value, newUser);
  }

  Future<ServerEntity> getFromId(String id) async {
    return serverRepository.getServer(id);
  }

  Future<void> setCurrentServer(String serverId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("LastChannelId");
    await prefs.setString("LastServerId", serverId);

    final ServerEntity server = await serverRepository.get(
      serverId,
      options: const ServerQueryOptions(
        includeMembers: true,
        includeChannels: true,
      ),
    );

    currentServer(server);
    _channelController.setCurrentChannel(server.channels[0]);
  }

  Future<void> listenForChanges() async {
    await listener?.cancel();

    listener = serverRepository.firestore
        .collection("Servers")
        .doc(currentServer.value.id)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> event) {
      if (event.data() == null) {
        return;
      }

      setCurrentServer(event.data()!['Id']);
    });
  }
}
