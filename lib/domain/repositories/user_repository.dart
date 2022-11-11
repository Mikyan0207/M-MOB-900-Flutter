import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/group_repository.dart';
import 'package:starlight/domain/repositories/server_repository.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = "Users";

  Future<List<ServerEntity>> _getUserServers(List<dynamic> serverIds) async {
    final ServerRepository serverRepository = ServerRepository();

    final List<ServerEntity> servers = await Future.wait(
      serverIds
          .map((dynamic id) async => serverRepository.get(id.toString()))
          .toList(),
    );

    return servers;
  }

  Future<List<GroupEntity>> _getUserGroups(List<dynamic> groupIds) async {
    final GroupRepository groupRepository = GroupRepository();

    final List<GroupEntity> groups = await Future.wait(
      groupIds
          .map((dynamic id) async => groupRepository.get(id.toString()))
          .toList(),
    );

    return groups;
  }

  Future<List<UserEntity>> _getUserFriends(List<dynamic> friendIds) async {
    final List<UserEntity> friends = await Future.wait(
      friendIds.map((dynamic id) async => get(id.toString())).toList(),
    );

    return friends;
  }

  Future<UserEntity> get(
    String id, {
    UserQueryOptions options = const UserQueryOptions(),
  }) async {
    final Map<String, dynamic>? data =
        (await _firestore.collection(collection).doc(id).get()).data();

    if (data == null) {
      return UserEntity();
    }

    final UserEntity user = UserEntity.fromJson(data);

    if (options.includeServers) {
      user.servers = await _getUserServers(data['Servers']);
    }

    if (options.includeGroups) {
      user.groups = await _getUserGroups(data['Groups']);
    }

    if (options.includeFriends) {
      user.friends = await _getUserFriends(data['Friends']);
    }

    return user;
  }

  Future<List<UserEntity>> getWhereArrayContains(
    String field,
    Object value,
  ) async {
    final List<Map<String, dynamic>> data = (await _firestore
            .collection(collection)
            .where(field, arrayContains: value)
            .get())
        .docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data())
        .toList();

    return UserEntity.fromJsonList(data);
  }

  Future<UserEntity?> getUserByUsernameAndDiscriminator(
    String username,
    String discriminator, {
    UserQueryOptions options = const UserQueryOptions(),
  }) async {
    final Map<String, dynamic> data = (await _firestore
            .collection(collection)
            .where('Username', isEqualTo: username)
            .where('Discriminator', isEqualTo: '#$discriminator')
            .snapshots()
            .first)
        .docs
        .first
        .data();

    if (data['Id'] == null) {
      return null;
    }

    final UserEntity user = UserEntity.fromJson(data);

    if (options.includeServers) {
      user.servers = await _getUserServers(data['Servers']);
    }

    if (options.includeGroups) {
      user.groups = await _getUserGroups(data['Groups']);
    }

    if (options.includeFriends) {
      user.friends = await _getUserFriends(data['Friends']);
    }

    return user;
  }

  Future<UserEntity> getByAuthId(
    String id, {
    UserQueryOptions options = const UserQueryOptions(),
  }) async {
    final Map<String, dynamic> data = (await _firestore
            .collection(collection)
            .where('AuthId', isEqualTo: id)
            .snapshots()
            .first)
        .docs
        .first
        .data();

    final UserEntity user = UserEntity.fromJson(data);

    if (options.includeServers) {
      user.servers = await _getUserServers(data['Servers']);
    }

    if (options.includeGroups) {
      user.groups = await _getUserGroups(data['Groups']);
    }

    if (options.includeFriends) {
      user.friends = await _getUserFriends(data['Friends']);
    }

    return user;
  }

  Future<UserEntity> create(UserEntity e) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection(collection).add(e.toJson());

    e.id = document.id;

    await document.set(<String, dynamic>{'Id': e.id});

    return e;
  }

  Future<UserEntity> update(UserEntity ue) async {
    await _firestore.collection(collection).doc(ue.id).update(ue.toJson());
    return ue;
  }

  Future<UserEntity> updateField(
    UserEntity ue,
    Map<String, dynamic> values, {
    bool merge = false,
  }) async {
    await _firestore
        .collection(collection)
        .doc(ue.id)
        .set(values, SetOptions(merge: merge));
    return ue;
  }

  Future<int> getUsersCount() async {
    return (await _firestore.collection(collection).count().get()).count;
  }
}
