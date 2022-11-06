import 'package:flutter/material.dart';
import 'package:starlight/presentation/home/home_screen.dart';
import '../../common/constants/route_constants.dart';

class HomeRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return <String, WidgetBuilder>{
      RouteList.home: (BuildContext context) => Home(),
    };
  }
}
