import 'package:get/get.dart';
import 'package:loop_auth_module/loop_auth_manager.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  void increment() async {
    await LoopAuthManager().requestExternalClientToken(
      userTel: '+821099991111',
      userId: 'a76df653-e04a-44af-a389-f064fc72327a',
    );
    LoopAuthManager().sendHealthSampleData();
  }

  void decrement() {}
}
