import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraXController extends GetxController {

  late final List<CameraDescription> cameras;
  late final CameraDescription firstCamera;
  late CameraDescription camera;

  Future<void> initCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;
    camera = firstCamera;
  }

  CameraDescription getCamera()  {
    return camera;
  }
}