import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight/domain/controllers/camera_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/presentation/picture/take_picture_screen.dart';
import 'package:starlight/presentation/user_info/alert_dialog_widget_change_info.dart';
import 'package:starlight/presentation/user_info/avatar_clipper.dart';
import 'package:starlight/presentation/widgets/custom_button.dart';
import 'package:starlight/presentation/widgets/profile_widget.dart';
import 'package:velocity_x/velocity_x.dart';

const Color darkColor = Color(0xFF49535C);

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  XFile? imageFile;

  File? imageFile2;

  String? imageUrl;

  String? myImage;

  String? myName;

  String? extension;

  //final UserController auth = Get.put(UserController());
  final CameraXController camera = Get.put(CameraXController());
  final UserController auth = Get.find();

  // todo create a widget
  void _showImageDialog(
    BuildContext context,
    String title,
    List<Widget> widgetChildren,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: widgetChildren,
          ),
        );
      },
    );
  }

  void _getFromCamera() async {
    // todo try this code on mobile phone + hide this choice for web
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    imageFile = XFile(pickedFile!.path);
    if (imageFile != null) {
      _addGoodExtension(pickedFile.name);
      _cropImage(pickedFile.path);
    }
  }

  void _getFromGallery() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    imageFile = XFile(pickedFile!.path);
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
      uploadImage();
    }
  }

  void _addGoodExtension(String name) {
    extension = name.split('.').last.toString();
  }

  void uploadImage() async {
    if (imageFile == null) {
      await Fluttertoast.showToast(msg: "Please select an Image");
      return;
    }

    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('userAvatarProfile/')
          .child(DateTime.now().toString());
      final SettableMetadata newMetadata = SettableMetadata(
        cacheControl: "public,max-age=300",
        contentType: "image/$extension",
      );

      await ref.putData(await imageFile!.readAsBytes(), newMetadata);
      imageUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser.value.id)
          .update(<String, Object?>{
        'Avatar': imageUrl,
      });
      imageFile = null;
      extension = null;
      await Fluttertoast.showToast(msg: "Image uploaded");
      await Get.to(const UserInfoScreen());
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Vx.gray800,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: AvatarClipper(),
                            child: Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                color: darkColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 11,
                            top: 50,
                            child: Row(
                              children: <Widget>[
                                ProfileWidget(
                                  showEdit: true,
                                  onClicked: () async {
                                    _showImageDialog(
                                      context,
                                      "Choose an option",
                                      <Widget>[
                                        InkWell(
                                          onTap: () async {
                                            if (kIsWeb) {
                                              await camera.initCamera();
                                              await Get.to(
                                                const TakePictureScreen(),
                                              );
                                            } else {
                                              _getFromCamera();
                                            }
                                          },
                                          child: Row(
                                            children: const <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.camera,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Text(
                                                "Camera",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _getFromGallery();
                                          },
                                          child: Row(
                                            children: const <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Text(
                                                "Image",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      auth.currentUser.value.username,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                        vertical: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                "Username:",
                              ),
                              Obx(
                                () => Text(
                                  "${auth.currentUser.value.username}\n\n",
                                ),
                              ),
                              const Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                "Email:",
                              ),
                              Obx(
                                () => Text(
                                  "${auth.currentUser.value.email}\n\n",
                                ),
                              ),
                              const Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                "Password: \n *******",
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              CustomButton(
                                customText: "Modify",
                                onClicked: () {
                                  displayModifyInfoDialog(
                                    context,
                                    "Change your username",
                                    "Username",
                                  );
                                },
                              ),
                              const SizedBox(height: 40),
                              CustomButton(
                                customText: "Modify",
                                onClicked: () {
                                  displayModifyInfoDialog(
                                    context,
                                    "Change your email",
                                    "Email",
                                  );
                                },
                              ),
                              const SizedBox(height: 40),
                              CustomButton(
                                customText: "Modify",
                                onClicked: () {
                                  displayModifyInfoDialog(
                                    context,
                                    "Modify your password",
                                    "password",
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
