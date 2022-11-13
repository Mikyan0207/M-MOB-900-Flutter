import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/channel_repository.dart';
import 'package:starlight/domain/repositories/server_repository.dart';
import 'package:starlight/domain/repositories/user_repository.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateServerDialog extends StatefulWidget {
  const CreateServerDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateServerDialog> createState() => _CreateServerDialogState();
}

class _CreateServerDialogState extends State<CreateServerDialog> {
  final UserController _userController = Get.find();

  final ServerRepository _serverRepository = ServerRepository();
  final ChannelRepository _channelRepository = ChannelRepository();
  final UserRepository _userRepository = UserRepository();

  final TextEditingController _serverNameController = TextEditingController();

  XFile? imageFile;
  Rx<String> imagePath = ''.obs;
  String? imageExtension;
  String? imageUrl;

  Future<void> _getFromGallery() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    imagePath(pickedFile!.path);
    imageFile = XFile(pickedFile.path);
    if (imageFile != null) {
      _addGoodExtension(pickedFile.name);
      _cropImage(pickedFile.path);
    }
  }

  void _cropImage(String filePath) async {
    final CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 2080,
      maxWidth: 2080,
      aspectRatioPresets: <CropAspectRatioPreset>[
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedImage != null) {
      imageFile = XFile(croppedImage.path);
      imagePath(croppedImage.path);
    }
  }

  void _addGoodExtension(String name) {
    imageExtension = name.split('.').last.toString();
  }

  ImageProvider<Object> _getImage() {
    if (imagePath.value.isEmptyOrNull) {
      return const AssetImage("assets/server_icon_placeholder.png");
    } else {
      return NetworkImage(imagePath.value);
    }
  }

  Future<void> createServer() async {
    if (_serverNameController.text.isEmptyOrNull) {
      return;
    }

    final ServerEntity server = await _serverRepository.create(
      ServerEntity(
        name: _serverNameController.text.trim(),
        members: <UserEntity>[
          UserEntity(
            id: _userController.currentUser.value.id,
            role: 'creator',
          ),
        ],
      ),
    );

    final String serverIcon = await uploadImage(server.id);
    final ChannelEntity defaultChannel = await _channelRepository.create(
      ChannelEntity(
        name: "general",
        description: "The main channel of ${server.name}",
        server: server,
      ),
    );

    await _serverRepository.updateField(
      server,
      <String, dynamic>{'Icon': serverIcon},
      merge: true,
    );
    await _serverRepository.updateField(
      server,
      <String, dynamic>{
        'Channels': FieldValue.arrayUnion(<dynamic>[
          <String, dynamic>{
            'Id': defaultChannel.id,
            'Name': defaultChannel.name,
          }
        ]),
      },
      merge: true,
    );

    await _userRepository.updateField(
      _userController.currentUser.value,
      <String, dynamic>{
        'Servers': FieldValue.arrayUnion(
          <dynamic>[
            server.id,
          ],
        )
      },
      merge: true,
    );

    await _userController.setCurrentUser('');
    Get.back();
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
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 12.0,
                      top: 12.0,
                      bottom: 6.0,
                    ),
                    child: Text(
                      "Create your server",
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
                      "Give your new server a personality with a name and an icon.",
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 26.0),
                              child: Center(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Obx(
                                    () => ClipRRect(
                                      borderRadius: imagePath.value.isEmpty
                                          ? BorderRadius.circular(0.0)
                                          : BorderRadius.circular(50.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Ink.image(
                                          image: _getImage(),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await _getFromGallery();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Text(
                                "SERVER NAME",
                                style: TextStyle(
                                  color: Vx.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _serverNameController,
                              style: const TextStyle(
                                color: AppColors.white,
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColors.black900,
                                prefixIcon: Icon(
                                  Icons.star_rounded,
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
                              onPressed: createServer,
                              child: const Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Vx.gray100,
                                  fontSize: 16.0,
                                ),
                              ),
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

  Future<String> uploadImage(String serverId) async {
    if (imageFile == null) {
      await Fluttertoast.showToast(msg: "Please select an Image");
      return '';
    }

    try {
      final Reference ref =
          FirebaseStorage.instance.ref().child('servers/').child(serverId);
      final SettableMetadata newMetadata = SettableMetadata(
        cacheControl: "public,max-age=300",
        contentType: "image/$imageExtension",
      );

      await ref.putData(await imageFile!.readAsBytes(), newMetadata);
      imageUrl = await ref.getDownloadURL();
      imageFile = null;
      imageExtension = null;
      await Fluttertoast.showToast(msg: "Image uploaded");
      return imageUrl!;
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      return '';
    }
  }
}
