import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class ChannelEntity {
  ChannelEntity({
    this.id = '',
    this.name = '',
    this.description = '',
    this.members = const <UserEntity>[],
    this.messages = const <MessageEntity>[],
  });

  factory ChannelEntity.fromJson(dynamic json) => ChannelEntity(
        id: json['Id'] ?? '',
        name: json['Name'] ?? '',
        description: json['Description'] ?? '',
        members: json['Members'] != null
            ? UserEntity.fromJsonList(json['Members'])
            : const <UserEntity>[],
        messages: json['Messages'] != null
            ? MessageEntity.fromJsonList(json['Messages'])
            : const <MessageEntity>[],
      );

  static List<ChannelEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => ChannelEntity.fromJson(json)).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'Name': name,
      'Description': description,
      'Members': members,
      'Messages': messages,
    };
  }

  String id;
  String name;
  String description;
  List<UserEntity> members;
  List<MessageEntity> messages;
}
