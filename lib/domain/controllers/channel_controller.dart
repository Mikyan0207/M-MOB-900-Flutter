import 'package:get/get.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';
import 'package:starlight/domain/repositories/message_repository.dart';

class ChannelController extends GetxController {
  Rx<ChannelEntity> currentChannel = ChannelEntity().obs;
  RxList<MessageEntity> currentChannelMessages = <MessageEntity>[].obs;

  final MessageRepository _messageRepository = MessageRepository();

  void setCurrentChannel(ChannelEntity e) {
    currentChannel(e);
    print(currentChannel.value.id);

    // await getMessagesForCurrentChannel();
  }

  Future<void> getMessagesForCurrentChannel() async {
    if (currentChannel.value.id == '') {
      return Future<void>.error("Invalid Channel Id");
    }

    currentChannelMessages(
      await _messageRepository.getMessagesForChannel(currentChannel.value.id),
    );
  }
}
