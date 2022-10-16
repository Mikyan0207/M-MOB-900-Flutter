import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class ServerEntity {
  ServerEntity({
    this.id,
    this.name,
    this.description,
    this.icon,
    this.members,
    this.channels,
  });

  factory ServerEntity.fromJson(dynamic json) => ServerEntity(
        id: json['Id'],
        name: json['Name'],
        description: json['Description'],
        icon: json['Icon'],
        members: UserEntity.fromJsonList(json['Members']),
        channels: ChannelEntity.fromJsonList(json['Channels']),
      );

  static List<ServerEntity> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return <ServerEntity>[];
    }

    return jsonList.map((dynamic json) => ServerEntity.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'Id': id,
      'Name': name,
      'Description': description,
      'Icon': icon,
      'Members': members,
      'Channels': channels,
    };
  }

  String? id;
  String? name;
  String? description;
  String? icon;
  List<UserEntity>? members;
  List<ChannelEntity>? channels;
}
