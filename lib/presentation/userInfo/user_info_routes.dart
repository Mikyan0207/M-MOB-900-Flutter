import 'package:flutter/material.dart';
import 'package:starlight/presentation/userInfo/user_info_screen.dart';

import '../../common/constants/route_constants.dart';

class UserInfoRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return <String, WidgetBuilder>{
      RouteList.userInfo: (BuildContext context) => UserInfoScreen(),
    };
  }
}