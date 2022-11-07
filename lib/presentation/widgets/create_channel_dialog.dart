import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateChannelDialog extends GetView<ServerController> {
  CreateChannelDialog({
    Key? key,
  }) : super(key: key);

  final ChannelRepository _channelRepository = ChannelRepository();

  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _channelDescriptionController =
      TextEditingController();

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
                      "Create Channel",
                      style: TextStyle(
                        color: Vx.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      bottom: 20.0,
                    ),
                    child: Text(
                      "in ${controller.currentServer.value.name.toUpperCase()}",
                      style: const TextStyle(
                        color: Vx.gray300,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
                      child: Form(
                        key: UniqueKey(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Text(
                                "CHANNEL NAME",
                                style: TextStyle(
                                  color: Vx.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _channelNameController,
                              style: const TextStyle(
                                color: AppColors.white,
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColors.black900,
                                prefixIcon: Icon(
                                  Icons.numbers_rounded,
                                  color: Vx.gray300,
                                ),
                                focusColor: Vx.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.black900,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.black900,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Vx.red400,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 24.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "CHANNEL DESCRIPTION",
                                style: TextStyle(
                                  color: Vx.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _channelDescriptionController,
                              style: const TextStyle(
                                color: AppColors.white,
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColors.black900,
                                prefixIcon: Icon(
                                  Icons.info_rounded,
                                  color: Vx.gray300,
                                ),
                                focusColor: Vx.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.black900,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.black900,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Vx.red400,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                if (_channelNameController.text.isEmptyOrNull) {
                                  return;
                                }

                                final ChannelEntity result =
                                    await _channelRepository.create(
                                  ChannelEntity(
                                    name: _channelNameController.text.trim(),
                                    description: _channelDescriptionController
                                        .text
                                        .trim(),
                                    server: controller.currentServer.value,
                                  ),
                                );

                                if (result.id.isNotEmpty) {
                                  Get.back();
                                }
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
