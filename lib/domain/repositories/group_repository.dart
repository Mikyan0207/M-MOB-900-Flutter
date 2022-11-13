import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/user_repository.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserEntity>> _getGroupMembers(List<dynamic> userIds) async {
    final UserRepository userRepository = UserRepository();

    final List<UserEntity> members = await Future.wait(
      userIds
          .map((dynamic id) async => userRepository.get(id.toString()))
          .toList(),
    );

    return members;
  }

  Future<GroupEntity> get(
    String id, {
    GroupQueryOptions options = const GroupQueryOptions(),
  }) async {
    final Map<String, dynamic>? data =
        (await _firestore.collection("Groups").doc(id).get()).data();

    if (data == null) {
      return GroupEntity();
    }

    final GroupEntity group = GroupEntity.fromJson(data);

    if (options.includeMembers && data['Members'] != null) {
      group.members = await _getGroupMembers(data['Members']);
    }

    return group;
  }

  Future<void> create(GroupEntity ge) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Groups").add(ge.toJson());

    ge.id = document.id;
    await document.set(<String, dynamic>{'Id': ge.id}, SetOptions(merge: true));
  }

  Future<bool> exists(List<UserEntity> members) async {
    return (await _firestore
                .collection("Groups")
                .where(
                  "GroupId",
                  isEqualTo:
                      members.map((UserEntity e) => e.id).toList().join('-'),
                )
                .count()
                .get())
            .count >
        0;
  }

  Future<void> delete(GroupEntity ge) async {
    await _firestore.collection("Groups").doc(ge.id).delete();
  }

  Future<void> update(GroupEntity ge) async {
    await _firestore.collection("Groups").doc(ge.id).update(ge.toJson());
  }
}
