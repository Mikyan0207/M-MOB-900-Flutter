import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starlight/common/constants/route_constants.dart';
import 'package:starlight/presentation/routes.dart';
import 'package:starlight/presentation/themes/theme_data.dart';
import 'package:velocity_x/velocity_x.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (BuildContext context, Widget? child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        maxWidth: 3840,
        minWidth: 480,
        defaultScale: true,
        breakpoints: const <ResponsiveBreakpoint>[
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        background: Container(
          color: Vx.gray800,
        ),
      ),
      title: 'Starlight',
      debugShowCheckedModeBanner: false,
      routes: Routes.getAll(),
      initialRoute: RouteList.home,
      theme: appTheme(context),
    );
  }
}
