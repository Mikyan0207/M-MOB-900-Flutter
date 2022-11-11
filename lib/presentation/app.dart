import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/common/constants/route_constants.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/controllers/friends_controller.dart';
import 'package:starlight/domain/controllers/group_controller.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/private_message_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/controllers/user_controller.dart';
import 'package:starlight/presentation/home/home_screen.dart';
import 'package:starlight/presentation/routes.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';
import 'package:starlight/presentation/sign_up/sign_up_screen.dart';
import 'package:starlight/presentation/splash/splash_screen.dart';
import 'package:starlight/presentation/themes/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Starlight',
      home: const Home(),
      onInit: () => <void>{
        Get.lazyPut(() => UserController()),
        Get.lazyPut(() => ServerController()),
        Get.lazyPut(() => ChannelController()),
        Get.lazyPut(() => FriendsController()),
        Get.lazyPut(() => HomeController()),
        Get.lazyPut(() => PrivateMessageController()),
        Get.lazyPut(() => GroupController()),
      },
      onDispose: () async {
        final UserController userController = Get.find();

        await userController.repository
            .updateField(userController.currentUser.value, <String, dynamic>{
          'Status': "offline",
        });
      },
      getPages: <GetPage<Widget>>[
        GetPage<Widget>(
          name: '/SplashScreen',
          page: <Widget>() => const SplashScreen(),
        ),
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
      initialRoute: RouteList.splashScreen,
      theme: appTheme(context),
    );
  }
}
