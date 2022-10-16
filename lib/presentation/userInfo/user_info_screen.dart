import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../auth/auth_controller.dart';
import '../widgets/CustomButton.dart';
import '../widgets/ProfileWidget.dart';
import 'AvatarClipper.dart';

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

  final AuthController auth = Get.put(AuthController());

  void _showImageDialog(BuildContext context)
  {
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text("Choose an option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: ()
                    {
                     _getFromCamera();
                    },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                          "Camera",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: ()
                  {
                    _getFromGallery();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Image",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  void _getFromCamera() async
  {

  }

  void _getFromGallery() async
  {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    print(pickedFile?.path);
    imageFile = XFile(pickedFile!.path);
    if (imageFile != null)
    {
      _addGoodExtension(pickedFile.name);
      _cropImage(pickedFile.path);
    }
  }

  void _cropImage(String filePath) async
  {
    final CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 2080,
      maxWidth: 2080,
      aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: this.context,
        ),
      ],
    );

    if (croppedImage != null)
    {
      imageFile = XFile(croppedImage.path);
      _upload_image();
    }
  }

  void _addGoodExtension(String name)
  {
    extension = name.split('.').last.toString();
  }

  void _upload_image() async
  {
    /* todo code for ios and android
    if (imageFile2 == null)
    {
      Fluttertoast.showToast(msg: "Please select an Image");
      return;
    }
     */

    if (imageFile == null)
    {
      await Fluttertoast.showToast(msg: "Please select an Image");
      return;
    }

    try
    {
      //print(imageFile?.path);
      final Reference ref = FirebaseStorage.instance.ref().child('userAvatarProfile/').child(DateTime.now().toString());
      // if web
      final SettableMetadata newMetadata = SettableMetadata(
        cacheControl: "public,max-age=300",
        contentType: "image/$extension",
      );
      await ref.putData(await imageFile!.readAsBytes(), newMetadata);
      // todo add for IOS and Android (under this line)
      //await ref.putFile(imageFile2!);
      imageUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('Users').doc("doc").update({
      'Avatar': imageUrl,
      });
      imageFile = null;
      extension = null;
      await Fluttertoast.showToast(msg: "Image uploaded");
    }
    catch(e)
    {
      await Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:
        Material(
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
                  children: [
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
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
                              children: [
                                ProfileWidget(
                                  imagePath: "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png",
                                  onClicked: ()  {
                                    _showImageDialog(context);
                                  },
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Username",
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    SizedBox(height: 50),
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
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.bold),
                                "Username:",
                              ),
                              Text(
                                "Myusername \n\n",
                              ),
                              Text(
                                style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.bold),
                                "Email:",
                              ),
                              Text(
                                "MyEmail \n\n",
                              ),
                              Text(
                                style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.bold),
                                "Password: \n *******",
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomButton(
                                customText: "Modify",
                                onClicked: ()  {
                                  null;
                                },
                              ),
                              const SizedBox(height: 40),
                              CustomButton(
                                  customText: "Modify",
                                  onClicked: ()  {
                                    null;
                                  },
                              ),
                              const SizedBox(height: 40),
                              CustomButton(
                                customText: "Modify",
                                onClicked: ()  {
                                  null;
                                },
                              ),
                            ]
                          )
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
    throw UnimplementedError();
  }
}