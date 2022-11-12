import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/user_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final UserController _authController = Get.find();
  final UserRepository _userRepository = UserRepository();

  List<bool> _isChecked = <bool>[];

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(
      10,
      false,
    );
    Future<void>.delayed(Duration.zero, () async {
      _isChecked = List<bool>.filled(
        await _userRepository.getUsersCount() - 1,
        false,
      );
    });
  }

  List<dynamic> _parseUsers(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<dynamic> users = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data()['Friends'] ?? <dynamic>[],
        )
        .toList();

    return users.expand((dynamic element) => element).toList();
  }

  ListView _buildUsersList(List<dynamic> users) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      shrinkWrap: true,
      itemCount: users.length,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        final UserEntity ue = UserEntity.fromJson(users[index]);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.black800,
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(
                data: ThemeData(unselectedWidgetColor: Vx.gray400),
                child: CheckboxListTile(
                  activeColor: AppColors.primaryColor,
                  checkColor: Vx.white,
                  title: Text(
                    ue.username,
                    style: const TextStyle(
                      color: Vx.white,
                    ),
                  ),
                  secondary: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipOval(
                        child: Image.network(
                          ue.avatar,
                        ),
                      ),
                    ),
                  ),
                  tileColor: Vx.gray300,
                  value: _isChecked[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked[index] = value!;
                    });
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            width: 600,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black500,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      top: 16.0,
                      bottom: 6.0,
                    ),
                    child: Text(
                      "Add Friend",
                      style: TextStyle(
                        color: Vx.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: Obx(
                        () =>
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .where(
                                "Id",
                                isEqualTo: _authController.currentUser.value.id,
                              )
                              .snapshots(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot,
                          ) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              return _buildUsersList(
                                _parseUsers(snapshot.data!.docs),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          12.0,
                        ),
                        bottomRight: Radius.circular(
                          12.0,
                        ),
                      ),
                      color: AppColors.black700,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 100,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    6.0,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Vx.gray400,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () async {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                backgroundColor: AppColors.primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    6.0,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Vx.gray100,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () async {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
