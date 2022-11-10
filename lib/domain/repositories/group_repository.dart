import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<GroupEntity?> groupExistsWithSpecificMembers(
    List<UserEntity> members,
  ) async {
    // final QuerySnapshot<Map<String, dynamic>> data = await _firestore
    //     .collection("Groups")
    //     .where(
    //       "Members.Id",
    //       arrayContains: members.map((UserEntity e) => e.idDocument).toList(),
    //     )
    //     .snapshots()
    //     .first;

    return GroupEntity();
  }
}
