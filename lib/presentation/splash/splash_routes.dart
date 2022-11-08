import 'package:flutter/material.dart';
import 'package:starlight/common/constants/route_constants.dart';
import 'package:starlight/presentation/splash/splash_screen.dart';

class SignUpRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return <String, WidgetBuilder>{
      RouteList.splashScreen: (BuildContext context) => const SplashScreen(),
    };
  }
}
