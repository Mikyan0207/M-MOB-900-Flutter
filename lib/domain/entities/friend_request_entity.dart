import 'package:starlight/domain/entities/user_entity.dart';

class FriendRequestEntity {
  FriendRequestEntity({
    this.id = '',
    required this.fromUser,
    required this.toUser,
    this.accepted = false,
  });

  factory FriendRequestEntity.fromJson(dynamic json) => FriendRequestEntity(
        id: json['Id'] ?? '',
        fromUser: json['FromUser'] != null
            ? UserEntity.fromJson(json['FromUser'])
            : UserEntity(),
        toUser: json['ToUser'] != null
            ? UserEntity.fromJson(json['ToUser'])
            : UserEntity(),
        accepted: json['Accepted'] ?? false,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'FromUser': <String, dynamic>{
        'Id': fromUser.idDocument,
        'Username': fromUser.username,
        'Discriminator': fromUser.discriminator,
        'Avatar': fromUser.avatar,
      },
      'ToUser': <String, dynamic>{
        'Id': toUser.idDocument,
        'Username': toUser.username,
        'Discriminator': toUser.discriminator,
        'Avatar': toUser.avatar,
      },
      'Accepted': accepted,
    };
  }

  String id;
  UserEntity fromUser;
  UserEntity toUser;
  bool accepted;
}
