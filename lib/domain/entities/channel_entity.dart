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

  factory ChannelEntity.fromJson(dynamic json) {
    final ChannelEntity ce = ChannelEntity(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
    );

    if (json['Members'] != null) {
      ce.members = json['Members'];
    }

    if (json['Messages'] != null) {
      ce.messages = json['Messages'];
    }

    return ce;
  }

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
