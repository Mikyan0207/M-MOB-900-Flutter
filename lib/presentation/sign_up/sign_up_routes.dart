import 'package:flutter/material.dart';
import 'package:starlight/presentation/sign_up/sign_up_screen.dart';

import '../../common/constants/route_constants.dart';

class SignUpRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return <String, WidgetBuilder>{
      RouteList.signUp: (BuildContext context) => SignUpScreen(),
    };
  }
}
