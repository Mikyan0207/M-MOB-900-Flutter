import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class ServerEntity {
  ServerEntity({
    this.id = '',
    this.name = '',
    this.description = '',
    this.icon = '',
    this.members = const <UserEntity>[],
    this.channels = const <ChannelEntity>[],
    this.admin = const <UserEntity>[],
  });

  factory ServerEntity.fromJson(dynamic json) => ServerEntity(
        id: json['Id'] ?? '',
        name: json['Name'] ?? '',
        description: json['Description'] ?? '',
        icon: json['Icon'] ?? '',
        members: json['Members'] != null
            ? UserEntity.fromJsonList(json['Members'])
            : const <UserEntity>[],
        channels: json['Channels'] != null
            ? ChannelEntity.fromJsonList(json['Channels'])
            : const <ChannelEntity>[],
        admin: json['Admin'] != null
            ? UserEntity.fromJsonList(json['Admin'])
            : const <UserEntity>[],
      );

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
      'Members': members
          .map(
            (UserEntity ue) => <String, dynamic>{
              'Id': ue.id,
              'Username': ue.username,
              'Avatar': ue.avatar,
              'Discriminator': ue.discriminator,
            },
          )
          .toList(),
      'Channels': channels
          .map(
            (ChannelEntity ce) => <String, dynamic>{
              'Id': ce.id,
              'Name': ce.name,
              'Description': ce.description,
            },
          )
          .toList(),
      'Admin': admin
          .map(
            (UserEntity ue) => <String, dynamic>{
          'Id': ue.id,
          'Username': ue.username,
          'Avatar': ue.avatar,
          'Discriminator': ue.discriminator,
        },
      )
          .toList(),
    };
  }

  String id;
  String name;
  String description;
  String icon;
  List<UserEntity> members;
  List<ChannelEntity> channels;
  List<UserEntity> admin;
}
