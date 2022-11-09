import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class MessageEntity {
  MessageEntity({
    this.id = '',
    required this.author,
    this.content = '',
    this.channel,
    required this.time,
    this.group,
  });

  factory MessageEntity.fromJson(dynamic json) => MessageEntity(
        id: json['Id'],
        author: json['Author'] != null
            ? UserEntity.fromJson(json['Author'])
            : UserEntity(),
        content: json['Content'],
        channel: json['Channel'] != null
            ? ChannelEntity.fromJson(json['Channel'])
            : ChannelEntity(),
        group: json['Group'] != null
            ? GroupEntity.fromJson(json['Channel'])
            : GroupEntity(),
        time: json['Time'],
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'Author': <String, dynamic>{
        'Id': author.id,
        'Username': author.username,
        'Avatar': author.avatar,
        'Discriminator': author.discriminator,
      },
      'Content': content,
      'Channel': <String, dynamic>{
        'Id': channel?.id ?? '',
      },
      'Group': <String, dynamic>{
        'Id': group?.id ?? '',
      },
      'Time': time
    };
  }

  static List<MessageEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => MessageEntity.fromJson(json)).toList();

  String id;
  UserEntity author;
  String content;
  ChannelEntity? channel;
  Timestamp time;
  GroupEntity? group;
}
