import 'package:get/get.dart';
import 'package:starlight/domain/entities/channel_entity.dart';

class ChannelController extends GetxController {
  Rx<ChannelEntity> currentChannel = ChannelEntity().obs;

  void setCurrentChannel(ChannelEntity e) {
    currentChannel(e);
  }
}
