import 'package:get/get.dart';
import 'package:starlight/domain/entities/group_entity.dart';

class PrivateMessageController extends GetxController {
  Rx<GroupEntity> currentGroup = GroupEntity().obs;
}
