import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/entities/friend_request_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/friend_request_repository.dart';
import 'package:starlight/domain/repositories/user_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class InviteFriendToServerDialog extends StatefulWidget {
  const InviteFriendToServerDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<InviteFriendToServerDialog> createState() =>
      _InviteFriendToServerDialogState();
}

class _InviteFriendToServerDialogState
    extends State<InviteFriendToServerDialog> {
  final AuthController _authController = Get.find();
  final FriendRequestRepository _friendRequestRepository =
      FriendRequestRepository();
  final UserRepository _userRepository = UserRepository();
  final TextEditingController _textFieldController = TextEditingController();

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
                      left: 12.0,
                      top: 12.0,
                      bottom: 6.0,
                    ),
                    child: Text(
                      "Invite People",
                      style: TextStyle(
                        color: Vx.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 12.0,
                      bottom: 20.0,
                    ),
                    child: Text(
                      "You can add a person with their Starlight tag.",
                      style: TextStyle(
                        color: Vx.gray300,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.black800,
                        border: Border.all(color: AppColors.black900),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Form(
                        child: TextFormField(
                          controller: _textFieldController,
                          validator: (String? value) {
                            if (value.isEmptyOrNull) {
                              return null;
                            }

                            final List<String> parts = value!.split("#");

                            if (parts.length != 2) {
                              return 'Invalid Starlight username.';
                            }

                            return null;
                          },
                          style: const TextStyle(color: AppColors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.black900,
                            labelStyle: TextStyle(
                              color: Vx.gray300,
                              fontWeight: FontWeight.w300,
                            ),
                            hintText: "Enter a Username#0000",
                            hintStyle: TextStyle(
                              color: Vx.gray400,
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.alternate_email_rounded,
                              color: Vx.gray400,
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
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
                            width: 175,
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
                                "Invite",
                                style: TextStyle(
                                  color: Vx.gray100,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () async {
                                final String username =
                                    _textFieldController.text.trim();
                                final List<String> parts = username.split("#");

                                if (parts.length != 2) {
                                  return;
                                }

                                final UserEntity? toUser = await _userRepository
                                    .getUserFromUsernameAndDiscriminator(
                                  parts[0],
                                  parts[1],
                                );

                                if (toUser == null) {
                                  Get.back();
                                }

                                await _friendRequestRepository.create(
                                  FriendRequestEntity(
                                    fromUser: _authController.currentUser.value,
                                    toUser: toUser!,
                                  ),
                                );

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
