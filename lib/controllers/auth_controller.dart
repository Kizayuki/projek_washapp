// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_routes.dart';
import '../models/profile_model.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  Rx<User?> currentUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  Rx<Profile?> currentProfile = Rx<Profile?>(null);

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  void _initAuthListener() {
    _supabaseClient.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.initialSession) {
        currentUser.value = session?.user;
        if (session?.user != null) {
          await _fetchCurrentProfile(session!.user!.id);
          // PENTING: Pengalihan setelah profil dimuat
          if (currentProfile.value?.isAdmin == true) {
            Get.offAllNamed(AppRoutes.adminDashboard);
          } else {
            Get.offAllNamed(AppRoutes.home);
          }
        }
      } else if (event == AuthChangeEvent.signedOut) {
        currentUser.value = null;
        currentProfile.value = null;
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<void> _fetchCurrentProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select(
            '*, id',
          ) // Pastikan 'id' juga dipilih jika tidak dijamin ada di response
          .eq('id', userId)
          .single();
      currentProfile.value = Profile.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      Get.snackbar('Error Profil', 'Gagal memuat data profil: ${e.message}');
      currentProfile.value = null;
    } catch (e) {
      Get.snackbar('Error Profil', 'Gagal memuat data profil (umum): $e');
      currentProfile.value = null;
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      final AuthResponse response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      if (response.user != null) {
        // Redireksi akan ditangani oleh _initAuthListener setelah profil dimuat
        Get.snackbar('Berhasil', 'Login berhasil!');
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
          'is_admin': false,
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
      Get.snackbar('Berhasil', 'Logout berhasil!');
      // Redireksi ke login akan ditangani oleh _initAuthListener
    } on AuthException catch (e) {
      Get.snackbar('Error Logout', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat logout: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool get isAdmin => currentProfile.value?.isAdmin ?? false;
}
