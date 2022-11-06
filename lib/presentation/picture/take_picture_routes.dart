
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:starlight/presentation/picture/take_picture_screen.dart';
import '../../common/constants/route_constants.dart';

class TakePictureRoutes {

  static Map<String, WidgetBuilder> getAll() {
    return <String, WidgetBuilder>{
      RouteList.takePicture: (BuildContext context) => const TakePictureScreen(),
    };
  }
}