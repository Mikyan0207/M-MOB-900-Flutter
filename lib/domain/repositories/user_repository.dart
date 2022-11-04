import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class UserRepository {
  Future<UserEntity>? create(UserEntity e) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference<Map<String, dynamic>> document =
        await firestore.collection("Users").add(e.toJson());
    final Map<String, dynamic>? data =
        (await document.snapshots().first).data();

    return UserEntity.fromJson(data);
  }

  Future<UserEntity> get(String id) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Map<String, dynamic> data =
        (await firestore.collection("Users").where('Id', isEqualTo: id).get())
            .docs
            .first
            .data();

    print("Hello ${data['Servers'] as List<dynamic>}");

    final UserEntity user = UserEntity.fromJson(data);

    for (String serverId in data['Servers']) {
      print("getting severs $serverId");
      final Map<String, dynamic>? server =
          (await firestore.collection("Servers").doc(serverId).get()).data();

      if (server == null) continue;

      print(server);

      user.servers?.add(ServerEntity.fromJson(server));
    }

    print("Hello ${data['Servers']}");

    return user;
  }
}
