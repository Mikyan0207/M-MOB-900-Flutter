import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
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
            .collection("Servers")
            .where(
              "Id",
              isEqualTo: _serverController.currentServer.value.id,
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            if (_serverController.currentServer.value.id.isEmptyOrNull) {
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

              return FutureBuilder<UserEntity?>(
                future: _userController.repository.get(members[index]['Id']),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<Object?> snapshot,
                ) {
                  if (snapshot.data == null) {
                    return Container();
                  }

                  final UserEntity member = snapshot.data as UserEntity;
                  member.role = members[index]['Role'];

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
    return docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) {
            return e.data()['Members'];
          },
        )
        .expand((dynamic m) => m)
        .where((dynamic m) => m['Role'] == roleToShow)
        .toList();
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
            .firstWhere(
              (UserEntity u) => u.id == _userController.currentUser.value.id,
            )
            .role ==
        role;
  }

  void _setUserRole(UserEntity user, String role) async {
    try {
      _serverController.currentServer.value.members
          .firstWhere((UserEntity u) => u.id == user.id)
          .role = role;

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
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
    }
  }
}
