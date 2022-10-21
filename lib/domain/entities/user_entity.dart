import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/server_entity.dart';

class UserEntity {
  UserEntity({
    this.id,
    this.username,
    this.avatar,
    this.discriminator,
    this.email,
    this.servers,
  });

  UserEntity.copy(UserEntity ue)
      : this(
          id: ue.id,
          username: ue.username,
          avatar: ue.avatar,
          discriminator: ue.discriminator,
          email: ue.email,
          servers: ue.servers,
        );

  factory UserEntity.fromJson(dynamic json) {
    final UserEntity ue = UserEntity(
      id: json['Id'],
      username: json['Username'],
      avatar: json['Avatar'],
      discriminator: json['Discriminator'],
      email: json['Email'],
      servers: ServerEntity.fromJsonList(json['Servers']),
    );

    return ue;
  }

  static List<UserEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => UserEntity.fromJson(json)).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'Username': username,
      'Avatar': avatar,
      'Discriminator': discriminator,
      'Email': email,
      'Servers': servers,
    };
  }

  String? id;
  String? username;
  String? avatar;
  String? discriminator;
  String? email;
  List<ServerEntity>? servers;
}
