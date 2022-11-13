import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/friend_request_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/friend_request_repository.dart';
import 'package:starlight/domain/repositories/user_repository.dart';

enum FriendTabState {
  home,
  pending,
  requests,
}

class FriendsController extends GetxController {
  final RxList<UserEntity> currentUserFriends = <UserEntity>[].obs;
  final Rx<FriendTabState> currentTab = FriendTabState.home.obs;

  final FriendRequestRepository _friendRequestRepository =
      FriendRequestRepository();
  final UserController _userController = Get.find();

  Future<void> declineOrCancelFriendRequest(FriendRequestEntity fre) async {
    await _friendRequestRepository.delete(fre);
  }

  Future<void> acceptFriendRequest(FriendRequestEntity fre) async {
    final UserEntity toUser =
        await _userController.repository.get(fre.toUser.id);
    final UserEntity fromUser =
        await _userController.repository.get(fre.fromUser.id);

    await _userController.repository.updateField(
      toUser,
      <String, dynamic>{
        'Friends': FieldValue.arrayUnion(<dynamic>[fromUser.id])
      },
      merge: true,
    );

    await _userController.repository.updateField(
      fromUser,
      <String, dynamic>{
        'Friends': FieldValue.arrayUnion(<dynamic>[toUser.id])
      },
      merge: true,
    );

    await _friendRequestRepository.delete(fre);
    await _userController.setCurrentUser('');
  }

  void setCurrentTab(FriendTabState state) => currentTab(state);
}
