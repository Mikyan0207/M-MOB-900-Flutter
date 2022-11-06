import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/common/constants/route_constants.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/presentation/home/home_screen.dart';
import 'package:starlight/presentation/routes.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';
import 'package:starlight/presentation/sign_up/sign_up_screen.dart';
import 'package:starlight/presentation/themes/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Starlight',
      home: const Home(),
      onInit: () => <void>{
        Get.lazyPut(() => AuthController()),
        Get.lazyPut(() => ServerController()),
        Get.lazyPut(() => ChannelController()),
      },
      getPages: <GetPage<Widget>>[
        GetPage<Widget>(
          name: '/Home',
          page: <Widget>() => const Home(),
        ),
        GetPage<Widget>(
          name: '/SignInScreen',
          page: <Widget>() => SignInScreen(),
        ),
        GetPage<Widget>(
          name: '/SignUpScreen',
          page: <Widget>() => SignUpScreen(),
        ),
      ],
      debugShowCheckedModeBanner: false,
      routes: Routes.getAll(),
      initialRoute: RouteList.signIn,
      theme: appTheme(context),
    );
  }
}
