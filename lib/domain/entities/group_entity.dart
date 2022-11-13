import 'package:starlight/domain/entities/user_entity.dart';

class GroupQueryOptions {
  const GroupQueryOptions({
    this.includeMembers = false,
  });

  final bool includeMembers;
}

class GroupEntity {
  GroupEntity({
    this.id = '',
    this.groupId = '',
    this.name = '',
    this.icon = '',
    this.members = const <UserEntity>[],
  });

  factory GroupEntity.fromJson(
    dynamic json, {
    GroupQueryOptions options = const GroupQueryOptions(),
  }) =>
      GroupEntity(
        id: json['Id'] ?? '',
        groupId: json['GroupId'] ?? '',
        name: json['Name'] ?? '',
        members: json['Members'] != null && options.includeMembers
            ? UserEntity.fromJsonList(json['Members'])
            : const <UserEntity>[],
      );

  static List<GroupEntity> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => GroupEntity.fromJson(json)).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'GroupId': groupId,
      'Name': name,
      'Members': members
          .map(
            (UserEntity ue) => ue.id,
          )
          .toList(),
    };
  }

  String id;
  String groupId;
  String name;
  String icon;
  List<UserEntity> members;
}
