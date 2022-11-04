import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class MessageEntity {
  MessageEntity({
    this.id,
    this.author,
    this.content,
    this.channel,
    this.time,
  });

  factory MessageEntity.fromJson(dynamic json) => MessageEntity(
        id: json['Id'],
        author: UserEntity.fromJson(json['Author']),
        content: json['Content'],
        channel: ChannelEntity.fromJson(json['Content']),
        time: json['Content'],
      );

  static List<MessageEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => MessageEntity.fromJson(json)).toList();

  String? id;
  UserEntity? author;
  String? content;
  ChannelEntity? channel;
  Timestamp? time;
}