
import 'package:flutter/material.dart';
import 'package:starlight/presentation/signIn/signIn_routes.dart';
import 'package:starlight/presentation/signUp/signUp_routes.dart';

class Routes {
  static Map<String, WidgetBuilder> _getCombinedRoutes() => <String, WidgetBuilder>{
    ...SignInRoutes.getAll(),
    ...SignUpRoutes.getAll(),
  };

  static Map<String, WidgetBuilder> getAll() => _getCombinedRoutes();
}