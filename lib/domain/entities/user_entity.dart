import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';

class UserEntity {
  UserEntity({
    this.id = '',
    this.username = '',
    this.avatar = '',
    this.discriminator = '',
    this.email = '',
    this.servers = const <ServerEntity>[],
    this.groups = const <GroupEntity>[],
    this.friends = const <UserEntity>[],
    this.idDocument = '',
  });

  factory UserEntity.fromJson(dynamic json) => UserEntity(
        id: json['Id'] ?? '',
        idDocument: json['IdDocument'] ?? '',
        username: json['Username'] ?? '',
        avatar: json['Avatar'] ?? '',
        discriminator: json['Discriminator'] ?? '#0000',
        email: json['Email'] ?? '',
        servers: json['Servers'] != null
            ? ServerEntity.fromJsonList(json['Servers'])
            : const <ServerEntity>[],
        groups: json['Groups'] != null
            ? GroupEntity.fromJsonList(json['Groups'])
            : const <GroupEntity>[],
        friends: json['Friends'] != null
            ? UserEntity.fromJsonList(json['Friends'])
            : const <UserEntity>[],
      );

  static List<UserEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => UserEntity.fromJson(json)).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'IdDocument': idDocument,
      'Username': username,
      'Avatar': avatar,
      'Discriminator': discriminator,
      'Email': email,
      'Servers': servers
          .map(
            (ServerEntity se) => <String, dynamic>{
              'Id': se.id,
              'Name': se.name,
              'Description': se.description,
              'Icon': se.icon,
            },
          )
          .toList(),
      'Groups': groups.map(
        (GroupEntity ge) => <String, dynamic>{
          'Id': ge.id,
          'Name': ge.name,
          'Icon': ge.icon,
        },
      ),
      'Friends': friends.map(
        (UserEntity ue) => <String, dynamic>{
          'Id': ue.idDocument,
          'Username': ue.username,
          'Avatar': ue.avatar,
        },
      ),
    };
  }

  String id;
  String idDocument;
  String username;
  String avatar;
  String discriminator;
  String email;
  List<ServerEntity> servers;
  List<GroupEntity> groups;
  List<UserEntity> friends;
}
