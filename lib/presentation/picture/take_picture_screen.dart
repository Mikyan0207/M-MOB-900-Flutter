import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:starlight/domain/controllers/camera_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/presentation/userInfo/user_info_screen.dart';
import 'package:starlight/presentation/widgets/custom_button.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final CameraXController camera = Get.put(CameraXController());

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      camera.getCamera(),
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final XFile image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute<String>(
                builder: (BuildContext context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  DisplayPictureScreen({super.key, required this.imagePath});
  final String imagePath;
  final UserController auth = Get.find();

  void _cropImage(String filePath, BuildContext context) async {
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
      XFile? imageFile;
      imageFile = XFile(croppedImage.path);
      _uploadImage(imageFile);
    } else {
      await Fluttertoast.showToast(msg: "Cropped Image failed");
    }
  }

  void _uploadImage(XFile? imageFile) async {
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('userAvatarProfile/')
        .child(DateTime.now().toString());
    final SettableMetadata newMetadata = SettableMetadata(
      cacheControl: "public,max-age=300",
      contentType: "image/jpeg",
    );

    await ref.putData(await imageFile!.readAsBytes(), newMetadata);
    final String imageUrl = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.value.id)
        .update(<String, Object?>{
      'Avatar': imageUrl,
    });
    await Fluttertoast.showToast(msg: "Image uploaded");
    await Get.to(() => const UserInfoScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: <Widget>[
          Image.network(imagePath),
          Row(
            children: <Widget>[
              CustomButton(
                customText: 'Crop',
                onClicked: () {
                  _cropImage(imagePath, context);
                },
              ),
              CustomButton(
                customText: 'Upload Image',
                onClicked: () {
                  XFile? imageFile;
                  imageFile = XFile(imagePath);
                  _uploadImage(imageFile);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
