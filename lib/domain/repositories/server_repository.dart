import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class ServerRepository {
  Future<List<ServerEntity>> getAll() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return ServerEntity.fromJsonList(
      await firestore.collection("Servers").snapshots().toList(),
    );
  }

  Future<ServerEntity> create(ServerEntity server) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference<Map<String, dynamic>> document = await firestore.collection("Servers").add(server.toJson());
    final Map<String, dynamic>? data = (await document.snapshots().first).data();
    ServerEntity firestoreServer = ServerEntity.fromJson(data);

    firestoreServer.id = document.id;
    firestoreServer = await update(firestoreServer);

    return firestoreServer;
  }

  Future<ServerEntity> update(ServerEntity server) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection("Servers").doc(server.id).update(server.toJson());

    return server;
  }

  Future<ServerEntity> joinServer(ServerEntity server, UserEntity user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection("Users").doc(user.id).update(user.toJson());
    await firestore.collection("Servers").doc(server.id).update(server.toJson());

    return server;
  }
}
