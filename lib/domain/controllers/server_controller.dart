import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';

class ServerController extends GetxController {
  Rx<ServerEntity> currentServer = ServerEntity().obs;
  RxList<ChannelEntity> channels = <ChannelEntity>[].obs;

  final ChannelRepository _channelRepository = ChannelRepository();
  final ChannelController _channelController = Get.find();

  Future<void> getChannelsForCurrentServer() async {
    if (currentServer.value.id.isEmpty) {
      return;
    }

    channels(
      await _channelRepository.getServerChannels(currentServer.value.id),
    );

    currentServer.value.channels = channels;
    _channelController.setCurrentChannel(channels[0]);
  }

  Future<void> setCurrentServer(ServerEntity e) async {
    currentServer(e);
    await getChannelsForCurrentServer();
  }
}
