import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserEntity>? create(UserEntity e) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Users").add(e.toJson());
    e.id = document.id;
    await document.set(e.toJson());

    return e;
  }

  Future<UserEntity> update(UserEntity ue) async {
    await _firestore.collection("Users").doc(ue.id).update(ue.toJson());
    return ue;
  }

  Future<UserEntity> updateField(
    UserEntity ue,
    Map<String, dynamic> values, {
    bool merge = false,
  }) async {
    await _firestore
        .collection("Users")
        .doc(ue.id)
        .set(values, SetOptions(merge: merge));
    return ue;
  }

  Future<int> getUsersCount() async {
    return (await _firestore.collection("Users").count().get()).count;
  }

  Future<UserEntity?> getUserFromUsernameAndDiscriminator(
    String username,
    String discriminator,
  ) async {
    final Map<String, dynamic> data = (await _firestore
            .collection("Users")
            .where('Username', isEqualTo: username)
            .where('Discriminator', isEqualTo: '#$discriminator')
            .snapshots()
            .first)
        .docs
        .first
        .data();

    if (data['Id'] == null) {
      return null;
    }

    return UserEntity.fromJson(data);
  }

  Future<UserEntity> get(String id) async {
    final Map<String, dynamic>? data =
        (await _firestore.collection("Users").doc(id).get()).data();

    return UserEntity.fromJson(data);
  }

  Future<UserEntity> getByAuthId(String id) async {
    final Map<String, dynamic> data = (await _firestore
            .collection("Users")
            .where('AuthId', isEqualTo: id)
            .snapshots()
            .first)
        .docs
        .first
        .data();

    return UserEntity.fromJson(data);
  }
}
