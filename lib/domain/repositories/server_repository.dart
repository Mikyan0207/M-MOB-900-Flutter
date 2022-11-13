import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class ServerRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<ServerEntity>> getAll({
    ServerQueryOptions options = const ServerQueryOptions(),
  }) async {
    return ServerEntity.fromJsonList(
      await firestore.collection("Servers").snapshots().toList(),
    );
  }

  Future<ServerEntity> get(
    String id, {
    ServerQueryOptions options = const ServerQueryOptions(),
  }) async {
    final Map<String, dynamic>? data =
        (await firestore.collection("Servers").doc(id).get()).data();

    if (data == null) {
      return ServerEntity();
    }

    return ServerEntity.fromJson(data, options: options);
  }

  Future<ServerEntity> getServer(String serverId) async {
    return ServerEntity.fromJson(
      (await firestore.collection("Servers").doc(serverId).get()).data(),
    );
  }

  Future<ServerEntity> create(ServerEntity se) async {
    final DocumentReference<Map<String, dynamic>> document =
        await firestore.collection("Servers").add(se.toJson());

    se.id = document.id;
    await document.set(se.toJson());

    return se;
  }

  Future<void> delete(ServerEntity se) async {
    await firestore.collection("Servers").doc(se.id).delete();
  }

  Future<ServerEntity> update(ServerEntity server) async {
    await firestore
        .collection("Servers")
        .doc(server.id)
        .update(server.toJson());

    return server;
  }

  Future<ServerEntity> updateField(
    ServerEntity se,
    Map<String, dynamic> values, {
    bool merge = false,
  }) async {
    await firestore
        .collection("Servers")
        .doc(se.id)
        .set(values, SetOptions(merge: merge));
    return se;
  }

  Future<ServerEntity> joinServer(ServerEntity server, UserEntity user) async {
    await firestore.collection("Users").doc(user.id).set(
      <String, dynamic>{
        'Servers': FieldValue.arrayUnion(
          <dynamic>[
            server.id,
          ],
        ),
      },
      SetOptions(merge: true),
    );

    await firestore.collection("Servers").doc(server.id).set(
      <String, dynamic>{
        'Members': FieldValue.arrayUnion(<dynamic>[
          <String, dynamic>{
            'Id': user.id,
            'Role': "member",
          }
        ])
      },
      SetOptions(merge: true),
    );

    return server;
  }
}
