import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class GroupEntity {
  GroupEntity({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.members = const <UserEntity>[],
    this.messages = const <MessageEntity>[],
  });

  factory GroupEntity.fromJson(dynamic json) => GroupEntity(
        id: json['Id'] ?? '',
        name: json['Name'] ?? '',
        members: json['Members'] != null
            ? UserEntity.fromJsonList(json['Members'])
            : const <UserEntity>[],
        messages: json['Messages'] != null
            ? MessageEntity.fromJsonList(json['Messages'])
            : const <MessageEntity>[],
      );

  static List<GroupEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => GroupEntity.fromJson(json)).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'Name': name,
      'Members': members,
      'Messages': messages,
    };
  }

  String id;
  String name;
  String icon;
  List<UserEntity> members;
  List<MessageEntity> messages;
}
