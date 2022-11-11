import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';

class ServerQueryOptions {
  const ServerQueryOptions({
    this.includeMembers = false,
    this.includeChannels = false,
  });

  final bool includeMembers;
  final bool includeChannels;
}

class ServerEntity {
  ServerEntity({
    this.id = '',
    this.name = '',
    this.description = '',
    this.icon = '',
    this.members = const <UserEntity>[],
    this.channels = const <ChannelEntity>[],
  });

  factory ServerEntity.fromJson(
    dynamic json, {
    ServerQueryOptions options = const ServerQueryOptions(),
  }) =>
      ServerEntity(
        id: json['Id'] ?? '',
        name: json['Name'] ?? '',
        description: json['Description'] ?? '',
        icon: json['Icon'] ?? '',
        members: json['Members'] != null && options.includeMembers
            ? UserEntity.fromJsonList(json['Members'])
            : const <UserEntity>[],
        channels: json['Channels'] != null && options.includeChannels
            ? ChannelEntity.fromJsonList(json['Channels'])
            : const <ChannelEntity>[],
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
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  String id;
  String name;
  String description;
  String icon;
  List<UserEntity> members;
  List<ChannelEntity> channels;
}
