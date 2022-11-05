import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class MessageEntity {
  MessageEntity({
    this.id,
    this.author,
    this.content,
    this.channelId,
    this.time,
  });

  factory MessageEntity.fromJson(dynamic json) => MessageEntity(
        id: json['Id'],
        author: UserEntity.fromJson(json['Author']),
        content: json['Content'],
        channelId: json['ChannelId'],
        time: json['Time'],
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'Author': <String, dynamic>{
        'Id': author?.id,
        'Username': author?.username,
        'Avatar': author?.avatar,
        'Discriminator': author?.discriminator,
      },
      'Content': content,
      'ChannelId': channelId,
      'Time': time
    };
  }

  static List<MessageEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => MessageEntity.fromJson(json)).toList();

  String? id;
  UserEntity? author;
  String? content;
  String? channelId;
  Timestamp? time;
}
