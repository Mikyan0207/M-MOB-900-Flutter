import 'package:starlight/domain/entities/server_entity.dart';

class UserEntity {
  UserEntity({
    this.id = '',
    this.username = '',
    this.avatar = '',
    this.discriminator = '',
    this.email = '',
    this.servers = const <ServerEntity>[],
    this.idDocument = '',
    this.role = '',
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
        role: json['Role'] ?? '',
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
    };
  }

  Map<String, dynamic> toJsonSimplifiedWithRole(String role) {
    return <String, dynamic>{
      'Id': id,
      'Username': username,
      'Avatar': avatar,
      'Discriminator': discriminator,
      'Role': role,
    };
  }

  String id;
  String idDocument;
  String username;
  String avatar;
  String discriminator;
  String email;
  List<ServerEntity> servers;
  String role;
}
