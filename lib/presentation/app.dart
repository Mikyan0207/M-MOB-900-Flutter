import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/common/constants/route_constants.dart';
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
      // builder: (BuildContext context, Widget? child) => ResponsiveWrapper.builder(
      //   BouncingScrollWrapper.builder(context, child!),
      //   maxWidth: 3840,
      //   minWidth: 480,
      //   defaultScale: true,
      //   breakpoints: const <ResponsiveBreakpoint>[
      //     ResponsiveBreakpoint.resize(450, name: MOBILE),
      //     ResponsiveBreakpoint.resize(800, name: TABLET),
      //     ResponsiveBreakpoint.resize(1000, name: TABLET),
      //     ResponsiveBreakpoint.resize(1200, name: DESKTOP),
      //     ResponsiveBreakpoint.autoScale(2460, name: "4K"),
      //   ],
      //   background: Container(
      //     color: Vx.gray800,
      //   ),
      // ),
      title: 'Starlight',
      home: const Home(),
      getPages: <GetPage<Widget>>[
        GetPage<Widget>(name: '/', page: <Widget>() => const Home()),
        GetPage<Widget>(name: '/SignInScreen', page: <Widget>() => SignInScreen()),
        GetPage<Widget>(name: '/SignUpScreen', page: <Widget>() => SignUpScreen()),
      ],
      debugShowCheckedModeBanner: false,
      routes: Routes.getAll(),
      initialRoute: RouteList.userInfo,
      theme: appTheme(context),
    );
  }
}
