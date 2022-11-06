import 'package:get/get.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';
import 'package:starlight/domain/repositories/server_repository.dart';

class ServerController extends GetxController {
  Rx<ServerEntity> currentServer = ServerEntity().obs;
  Rx<ChannelEntity> currentChannel = ChannelEntity().obs;

  RxList<ServerEntity> servers = <ServerEntity>[].obs;
  RxList<ChannelEntity> channels = <ChannelEntity>[].obs;

  final ServerRepository _serverRepository = ServerRepository();
  final ChannelRepository _channelRespository = ChannelRepository();

  void setServersFromUser(UserEntity ue) {
    if (ue.servers == null) {
      return;
    }

    if (ue.servers!.isEmpty) {
      return;
    }

    servers(ue.servers!);
    currentServer(servers[0]);
  }

  Future<List<ServerEntity>> getServersAsync() async {
    servers(await _serverRepository.getAll());

    return servers;
  }

  Future<ServerEntity> getServerAsync(String serverId) async {
    final ServerEntity server = await _serverRepository.getServer(serverId);

    currentServer(server);
    channels(await getChannelsForCurrentServer());

    return server;
  }

  Future<List<ChannelEntity>> getChannelsForCurrentServer() async {
    if (currentServer.value.id?.isEmpty ?? true) {
      return channels;
    }

    channels(
        await _channelRespository.getServerChannels(currentServer.value.id!));

    return channels;
  }

  void setCurrentServer(ServerEntity e) => currentServer(e);
}
