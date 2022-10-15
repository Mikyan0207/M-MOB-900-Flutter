
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starlight/presentation/home/home_routes.dart';
import 'package:starlight/presentation/sign_in/sign_in_routes.dart';
import 'package:starlight/presentation/sign_up/sign_up_routes.dart';
import 'package:starlight/presentation/userInfo/user_info_routes.dart';

class Routes {
  static Map<String, WidgetBuilder> _getCombinedRoutes() => <String, WidgetBuilder>{
    ...SignInRoutes.getAll(),
    ...SignUpRoutes.getAll(),
    ...HomeRoutes.getAll(),
    ...UserInfoRoutes.getAll(),
  };

  static Map<String, WidgetBuilder> getAll() => _getCombinedRoutes();
}