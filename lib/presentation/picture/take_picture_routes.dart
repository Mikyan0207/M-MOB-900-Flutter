import 'package:flutter/material.dart';
import 'package:starlight/common/constants/route_constants.dart';
import 'package:starlight/presentation/picture/take_picture_screen.dart';

class TakePictureRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return <String, WidgetBuilder>{
      RouteList.takePicture: (BuildContext context) =>
          const TakePictureScreen(),
    };
  }
}
