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

  factory ServerEntity.fromJson(dynamic json) {
    final ServerEntity e = ServerEntity();

    e.id = json['Id'];
    e.name = json['Name'];
    e.description = json['Description'];
    e.icon = json['Icon'];

    if (json['Members'] != null) {
      e.members = UserEntity.fromJsonList(json['Members']);
    }

    if (json['Channels'] != null) {
      e.channels = ChannelEntity.fromJsonList(json['Channels']);
    }

    return e;
  }

  static List<ServerEntity> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return <ServerEntity>[];
    }

    return jsonList.map((dynamic json) => ServerEntity.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
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
