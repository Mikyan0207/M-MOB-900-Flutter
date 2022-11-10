import 'package:flutter/material.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';
import '../../common/constants/route_constants.dart';

class SignInRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return <String, WidgetBuilder>{
      RouteList.signIn: (BuildContext context) => SignInScreen(),
    };
  }
}
