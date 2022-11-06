import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class UserRepository {
  Future<UserEntity>? create(UserEntity e) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference<Map<String, dynamic>> document =
        await firestore.collection("Users").add(e.toJson());
    e.idDocument = document.id;
    await document.set(e.toJson());

    final Map<String, dynamic>? data =
        (await document.snapshots().first).data();

    return UserEntity.fromJson(data);
  }

  Future<UserEntity> get(String id) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Map<String, dynamic> data = (await firestore
            .collection("Users")
            .where('Id', isEqualTo: id)
            .snapshots()
            .first)
        .docs
        .first
        .data();

    return UserEntity.fromJson(data);
  }
}
