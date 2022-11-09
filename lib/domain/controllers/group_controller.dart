import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/group_repository.dart';

class GroupController extends GetxController {
  final GroupRepository _groupRepository = GroupRepository();

  Future<GroupEntity> create(GroupEntity ge) async {
    await _groupRepository.create(ge);

    for (final UserEntity user in ge.members) {
      await FirebaseFirestore.instance.collection("Users").doc(user.id).set(
        <String, dynamic>{
          'Groups': FieldValue.arrayUnion(<dynamic>[ge.toJson()])
        },
        SetOptions(merge: true),
      );
    }

    return ge;
  }
}
