import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/group_repository.dart';

class GroupController extends GetxController {
  Rx<GroupEntity> currentGroup = GroupEntity().obs;

  final GroupRepository _groupRepository = GroupRepository();
  final UserController _userController = UserController();

  Future<GroupEntity> create(GroupEntity ge) async {
    if (await _groupRepository.exists(ge.members)) {
      final GroupEntity? existingGroup =
          _userController.currentUser.value.groups.firstWhereOrNull(
        (GroupEntity group) =>
            group.groupId == ge.members.map((UserEntity e) => e.id).join('-'),
      );

      if (existingGroup != null) {
        currentGroup(existingGroup);
      }

      return ge;
    }

    ge.groupId = ge.members.map((UserEntity e) => e.id).join('-');
    await _groupRepository.create(ge);

    for (final UserEntity user in ge.members) {
      await FirebaseFirestore.instance.collection("Users").doc(user.id).set(
        <String, dynamic>{
          'Groups': FieldValue.arrayUnion(<dynamic>[ge.id])
        },
        SetOptions(merge: true),
      );
    }

    return ge;
  }

  Future<void> setCurrentGroup(String groupId) async {
    final GroupEntity group = await _groupRepository.get(
      groupId,
      options: const GroupQueryOptions(
        includeMembers: true,
      ),
    );

    currentGroup(group);
  }
}
