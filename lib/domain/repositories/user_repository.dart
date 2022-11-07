import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserEntity>? create(UserEntity e) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Users").add(e.toJson());
    e.idDocument = document.id;
    await document.set(e.toJson());

    final Map<String, dynamic>? data =
        (await document.snapshots().first).data();

    return UserEntity.fromJson(data);
  }

  Future<void> update(UserEntity ue) async {
    await _firestore.collection("Users").doc(ue.id).set(ue.toJson());
  }

  Future<UserEntity> get(String id) async {
    final Map<String, dynamic> data = (await _firestore
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
