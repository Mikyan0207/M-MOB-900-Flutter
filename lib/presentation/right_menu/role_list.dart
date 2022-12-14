import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/widgets/member_card.dart';
import 'package:velocity_x/velocity_x.dart';

class RoleList extends StatelessWidget {
  RoleList({
    Key? key,
    required this.roleToShow,
  }) : super(key: key);

  final UserController _userController = Get.find();

  final String roleToShow;

  final ServerController _serverController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where(
              "Servers",
              arrayContains: _serverController.currentServer.value.id,
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            if (_serverController.currentServer.value.id.isEmptyOrNull ||
                snapshot.data!.docs.isEmpty) {
              return Container();
            } else {
              return _buildUsersList(
                _parseUsers(snapshot.data!.docs),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildUsersList(List<dynamic> members) {
    if (members.isEmpty) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "${roleToShow}S".toUpperCase(),
              style: const TextStyle(
                color: Vx.gray200,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(2.0),
            itemBuilder: (BuildContext context, int index) {
              if (members.isEmpty) {
                return Container();
              }

              final UserEntity member = UserEntity.fromJson(members[index]);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _isCurrentUserInRole("member") == false
                    ? ContextMenuRegion(
                        contextMenu: GenericContextMenu(
                          buttonConfigs: _getContextMenu(member),
                          buttonStyle: const ContextMenuButtonStyle(
                            textStyle: TextStyle(color: Vx.white),
                            shortcutTextStyle: TextStyle(color: Vx.white),
                          ),
                        ),
                        child: MemberCard(
                          member: member,
                        ),
                      )
                    : MemberCard(
                        member: member,
                      ),
              );
            },
            itemCount: members.length,
            shrinkWrap: true,
            controller: _scrollController,
          ),
        ],
      );
    }
  }

  List<dynamic> _parseUsers(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs.map(
      (
        QueryDocumentSnapshot<Map<String, dynamic>> e,
      ) {
        return e.data();
      },
    ).where((dynamic m) {
      return _serverController.currentServer.value.members
              .firstWhereOrNull((UserEntity e) => e.id == m['Id'])
              ?.role ==
          roleToShow;
    }).toList();
  }

  List<ContextMenuButtonConfig> _getContextMenu(UserEntity member) {
    if (_isCurrentUserInRole("creator") || _isCurrentUserInRole("admin")) {
      return <ContextMenuButtonConfig>[
        ContextMenuButtonConfig(
          "Set role to admin",
          onPressed: () => <void>{
            Future<void>.delayed(Duration.zero, () async {
              _setUserRole(member, "admin");
            }),
          },
        ),
        ContextMenuButtonConfig(
          "Set role to member",
          onPressed: () => <void>{
            Future<void>.delayed(Duration.zero, () async {
              _setUserRole(member, "member");
            }),
          },
        ),
      ];
    } else {
      return <ContextMenuButtonConfig>[];
    }
  }

  bool _isCurrentUserInRole(String role) {
    return _serverController.currentServer.value.members
            .firstWhereOrNull(
              (UserEntity u) => u.id == _userController.currentUser.value.id,
            )
            ?.role ==
        role;
  }

  void _setUserRole(UserEntity user, String role) async {
    try {
      final UserEntity? memberInfo = _serverController
          .currentServer.value.members
          .firstWhereOrNull((UserEntity u) => u.id == user.id);

      if (memberInfo == null) {
        return;
      }

      memberInfo.role = role;

      await _serverController.serverRepository.updateField(
        _serverController.currentServer.value,
        <String, dynamic>{
          'Members': _serverController.currentServer.value.members
              .map(
                (UserEntity e) => <String, dynamic>{
                  'Id': e.id,
                  'Role': e.id == user.id ? role : e.role,
                },
              )
              .toList()
        },
        merge: true,
      );

      await _userController.repository.updateField(
        user,
        <String, dynamic>{
          'Status': "${user.status} ",
        },
        merge: true,
      );
      await _userController.repository.updateField(
        user,
        <String, dynamic>{
          'Status': user.status.trim(),
        },
        merge: true,
      );
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
    }
  }
}
