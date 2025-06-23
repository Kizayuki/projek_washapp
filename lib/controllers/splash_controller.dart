import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 3)); // Durasi splash screen

    final session = supabase.auth.currentSession;
    if (session == null) {
      Get.offAllNamed(
        AppRoutes.LOGIN,
      ); // Pengguna belum login, arahkan ke Login
    } else {
      Get.offAllNamed(AppRoutes.HOME); // Pengguna sudah login, arahkan ke Home
    }
  }
}
