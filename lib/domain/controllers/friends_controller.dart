import 'package:get/get.dart';
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
  final UserRepository _userRepository = UserRepository();

  Future<void> declineOrCancelFriendRequest(FriendRequestEntity fre) async {
    await _friendRequestRepository.delete(fre);
  }

  Future<void> acceptFriendRequest(FriendRequestEntity fre) async {
    final UserEntity toUser = await _userRepository.get(fre.toUser.id);
    final UserEntity fromUser = await _userRepository.get(fre.fromUser.id);

    toUser.friends.add(fromUser);
    fromUser.friends.add(toUser);

    await _userRepository.update(toUser);
    await _userRepository.update(fromUser);

    fre.accepted = true;
    await _friendRequestRepository.update(fre);
  }

  void setCurrentTab(FriendTabState state) => currentTab(state);
}
