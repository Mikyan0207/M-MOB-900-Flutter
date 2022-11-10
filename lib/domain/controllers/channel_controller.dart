import 'package:get/get.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';

class ChannelController extends GetxController {
  Rx<ChannelEntity> currentChannel = ChannelEntity().obs;

  final ChannelRepository _channelRepository = ChannelRepository();

  Future<ChannelEntity> getFromId(String id) async {
    return _channelRepository.get(id);
  }

  void setCurrentChannel(ChannelEntity e) {
    currentChannel(e);
  }
}
