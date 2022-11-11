import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';
import 'package:starlight/domain/repositories/server_repository.dart';
import 'package:starlight/domain/repositories/user_repository.dart';

class ServerController extends GetxController {
  Rx<ServerEntity> currentServer = ServerEntity().obs;

  final ServerRepository serverRepository = ServerRepository();
  final ChannelRepository _channelRepository = ChannelRepository();
  final UserRepository _userRepository = UserRepository();
  final ChannelController _channelController = Get.find();

  Future<void> deleteCurrentServer() async {
    await serverRepository.delete(currentServer.value);
  }

  Future<void> joinServer(UserEntity newUser) async {
    await serverRepository.joinServer(currentServer.value, newUser);
  }

  Future<ServerEntity> getFromId(String id) async {
    return serverRepository.getServer(id);
  }

  Future<void> setCurrentServer(ServerEntity e) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("LastChannelId");
    await prefs.setString("LastServerId", e.id);

    if (e.channels.isEmpty) {
      e.channels = await _channelRepository.getWhereIsEqualTo(
        'Server.Id',
        e.id,
      );
    }

    if (e.members.isEmpty) {
      e.members = await _userRepository.getWhereArrayContains('Servers', e.id);
    }

    currentServer(e);
    _channelController.setCurrentChannel(e.channels[0]);
  }
}
