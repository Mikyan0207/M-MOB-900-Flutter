import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraXController extends GetxController {
  late List<CameraDescription> cameras;
  late CameraDescription firstCamera;
  late CameraDescription camera;

  Future<void> initCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;
    camera = firstCamera;
  }

  CameraDescription getCamera() {
    return camera;
  }
}
