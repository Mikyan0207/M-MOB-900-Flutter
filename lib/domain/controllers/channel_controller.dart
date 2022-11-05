import 'package:get/get.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/message_entity.dart';

class ChannelController extends GetxController {
  Rx<ChannelEntity> currentChannel = ChannelEntity().obs;
  RxList<MessageEntity> currentChannelMessages = <MessageEntity>[].obs;

  void setCurrentChannel(ChannelEntity e) {
    currentChannel(e);
  }
}
