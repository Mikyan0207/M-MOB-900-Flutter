import 'package:get/get.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class FriendsController extends GetxController {
  final RxList<UserEntity> currentUserFriends = <UserEntity>[].obs;
}
