import 'package:get/get.dart';

enum AppTab {
  friends,
  servers,
  privateMessage,
}

class HomeController extends GetxController {
  Rx<AppTab> tabSelected = AppTab.friends.obs;

  void setSelectedTab(AppTab value) => tabSelected(value);
}
