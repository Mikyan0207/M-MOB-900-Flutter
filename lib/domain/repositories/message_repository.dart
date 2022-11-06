import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/user_repository.dart';

class MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final UserRepository _userRepository = UserRepository();

  Future<List<MessageEntity>> getMessagesForChannel(String channelId) async {
    final List<Map<String, dynamic>> data = (await _firestore
            .collection("Messages")
            .where('ChannelId', isEqualTo: channelId)
            .get())
        .docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
      final Map<String, dynamic> r = e.data();

      r['Id'] = e.id;

      return r;
    }).toList();

    for (Map<String, dynamic> message in data) {
      final UserEntity author = await _userRepository.get(message['Author']);
      message['Author'] = author;
    }

    return MessageEntity.fromJsonList(data);
  }
}
