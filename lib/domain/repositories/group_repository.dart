import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/group_entity.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<GroupEntity> get(String id) async {
    final Map<String, dynamic>? data =
        (await _firestore.collection("Groups").doc(id).get()).data();

    return GroupEntity.fromJson(data);
  }

  Future<void> create(GroupEntity ge) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Groups").add(ge.toJson());

    ge.id = document.id;
    await document.set(ge.toJson());
  }

  Future<void> delete(GroupEntity ge) async {
    await _firestore.collection("Groups").doc(ge.id).delete();
  }

  Future<void> update(GroupEntity ge) async {
    await _firestore.collection("Groups").doc(ge.id).update(ge.toJson());
  }
}
