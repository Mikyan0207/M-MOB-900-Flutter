import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';

class UserQueryOptions {
  const UserQueryOptions({
    this.includeServers = false,
    this.includeGroups = false,
    this.includeFriends = false,
  });

  final bool includeServers;
  final bool includeGroups;
  final bool includeFriends;
}

class UserEntity {
  UserEntity({
    this.id = '',
    this.authId = '',
    this.username = '',
    this.avatar = '',
    this.discriminator = '',
    this.email = '',
    this.servers = const <ServerEntity>[],
    this.groups = const <GroupEntity>[],
    this.friends = const <UserEntity>[],
  });

  factory UserEntity.fromJson(
    dynamic json, {
    UserQueryOptions options = const UserQueryOptions(),
  }) =>
      UserEntity(
        id: json['Id'] ?? '',
        authId: json['AuthId'] ?? '',
        username: json['Username'] ?? '',
        avatar: json['Avatar'] ?? '',
        discriminator: json['Discriminator'] ?? '#0000',
        email: json['Email'] ?? '',
        servers: json['Servers'] != null && options.includeServers
            ? ServerEntity.fromJsonList(json['Servers'])
            : const <ServerEntity>[],
        groups: json['Groups'] != null && options.includeGroups
            ? GroupEntity.fromJsonList(json['Groups'])
            : const <GroupEntity>[],
        friends: json['Friends'] != null && options.includeFriends
            ? UserEntity.fromJsonList(json['Friends'])
            : const <UserEntity>[],
      );

  static List<UserEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => UserEntity.fromJson(json)).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'AuthId': authId,
      'Username': username,
      'Avatar': avatar,
      'Discriminator': discriminator,
      'Email': email,
      'Servers': servers.map((ServerEntity se) => <String>{se.id}).toList(),
      'Groups': groups.map((GroupEntity ge) => <String>{ge.id}).toList(),
      'Friends': friends.map((UserEntity ue) => <String>{ue.id}).toList(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  String id;
  String authId;
  String username;
  String avatar;
  String discriminator;
  String email;
  List<ServerEntity> servers;
  List<GroupEntity> groups;
  List<UserEntity> friends;
}
