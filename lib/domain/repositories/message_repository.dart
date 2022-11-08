import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/message_entity.dart';

class MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> delete(MessageEntity me) async {
    await _firestore.collection("Messages").doc(me.id).delete();
  }

  Future<MessageEntity> create(MessageEntity message) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Messages").add(message.toJson());

    message.id = document.id;
    await document.set(message.toJson());

    return message;
  }
}
