import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class ServerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ServerEntity>> getAll() async {
    return ServerEntity.fromJsonList(
      await _firestore.collection("Servers").snapshots().toList(),
    );
  }

  Future<ServerEntity> getServer(String serverId) async {
    return ServerEntity.fromJson(
      (await _firestore.collection("Servers").doc(serverId).get()).data(),
    );
  }

  Future<ServerEntity> create(ServerEntity server) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Servers").add(server.toJson());
    final Map<String, dynamic>? data =
        (await document.snapshots().first).data();
    ServerEntity firestoreServer = ServerEntity.fromJson(data);

    firestoreServer.id = document.id;
    firestoreServer = await update(firestoreServer);

    return firestoreServer;
  }

  Future<ServerEntity> update(ServerEntity server) async {
    await _firestore
        .collection("Servers")
        .doc(server.id)
        .update(server.toJson());

    return server;
  }

  Future<ServerEntity> joinServer(ServerEntity server, UserEntity user) async {
    await _firestore.collection("Users").doc(user.id).update(user.toJson());
    await _firestore
        .collection("Servers")
        .doc(server.id)
        .update(server.toJson());

    return server;
  }
}
