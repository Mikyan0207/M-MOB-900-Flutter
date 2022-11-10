import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';
import 'package:starlight/domain/repositories/server_repository.dart';

class ServerController extends GetxController {
  Rx<ServerEntity> currentServer = ServerEntity().obs;
  RxList<ChannelEntity> channels = <ChannelEntity>[].obs;

  final ServerRepository _serverRepository = ServerRepository();
  final ChannelRepository _channelRepository = ChannelRepository();
  final ChannelController _channelController = Get.find();

  Future<void> deleteCurrentServer() async {
    await _serverRepository.delete(currentServer.value);
  }

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

  Future<void> addUserToCurrentServer(UserEntity newUser) async {
    await _serverRepository.joinServer(currentServer.value, newUser);
  }

  Future<void> setCurrentServer(ServerEntity e) async {
    currentServer(e);
    await getChannelsForCurrentServer();
  }
}
