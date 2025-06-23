import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  Rx<User?> currentUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _supabaseClient.auth.currentUser;

    _supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.initialSession) {
        currentUser.value = session?.user;
      } else if (event == AuthChangeEvent.signedOut) {
        currentUser.value = null;
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      final AuthResponse response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      if (response.user != null) {
        Get.snackbar('Berhasil', 'Login berhasil!');
        Get.offAllNamed(AppRoutes.home);
      }
    } on AuthException catch (e) {
      Get.snackbar('Error Login', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan tidak dikenal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String username,
    String fullName,
    String phoneNumber,
  ) async {
    isLoading.value = true;
    try {
      final AuthResponse response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _supabaseClient.from('profiles').insert({
          'id': response.user!.id,
          'username': username,
          'full_name': fullName,
          'phone_number': phoneNumber,
        });
        Get.snackbar('Berhasil', 'Registrasi berhasil! Silakan login.');
        Get.offAllNamed(AppRoutes.login);
      }
    } on AuthException catch (e) {
      Get.snackbar('Error Registrasi', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan tidak dikenal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _supabaseClient.auth.signOut();
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('Berhasil', 'Logout berhasil!');
    } on AuthException catch (e) {
      Get.snackbar('Error Logout', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat logout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
