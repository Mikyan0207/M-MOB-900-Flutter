import 'package:get/get.dart';

enum AppTab {
  none,
  friends,
  privateMessage,
  servers,
}

class HomeController extends GetxController {
  Rx<AppTab> tabSelected = AppTab.none.obs;

  void setSelectedTab(AppTab value) => tabSelected(value);
}
