import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final GetStorage _box = GetStorage();
  RxBool isLoading = false.obs;

  User? get currentUser => supabase.auth.currentUser;
  RxString? currentUserName = RxString('').obs;

  @override
  void onInit() {
    super.onInit();
    _listenForAuthChanges();
    _loadUserName();
  }

  void _listenForAuthChanges() {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.initialSession) {
        if (session != null) {
          _fetchAndStoreUserProfile(session.user!.id);
        }
        if (Get.currentRoute != AppRoutes.HOME && Get.currentRoute != AppRoutes.SPLASH) {
          Get.offAllNamed(AppRoutes.HOME);
        }
      } else if (event == AuthChangeEvent.signedOut) {
        _box.remove('user_name');
        currentUserName?.value = '';
        Get.offAllNamed(AppRoutes.LOGIN);
      } else if (event == AuthChangeEvent.userUpdated) {
        if (session != null) {
          _fetchAndStoreUserProfile(session.user!.id);
        }
      }
    });
  }

  Future<void> _fetchAndStoreUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', userId)
          .single();

      if (response != null) {
        final name = response['full_name'] as String?;
        if (name != null) {
          await _box.write('user_name', name);
          currentUserName?.value = name;
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  void _loadUserName() {
    final name = _box.read('user_name');
    if (name != null) {
      currentUserName?.value = name;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String phoneNumber,
  }) async {
    isLoading.value = true;
    showLoading();
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('profiles').insert({
          'id': response.user!.id,
          'email': email,
          'username': username,
          'full_name': fullName,
          'phone_number': phoneNumber,
        });

        showSnackbar('Berhasil', 'Pendaftaran berhasil! Silakan login.');
        Get.offAllNamed(AppRoutes.LOGIN);
      } else if (response.user == null && response.session == null) {
        showSnackbar('Pendaftaran Berhasil', 'Silakan cek email Anda untuk verifikasi.', isError: false);
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } on AuthException catch (e) {
      showSnackbar('Error', e.message, isError: true);
    } catch (e) {
      showSnackbar('Error', 'Terjadi kesalahan: $e', isError: true);
    } finally {
      isLoading.value = false;
      hideLoading();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    showLoading();
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _fetchAndStoreUserProfile(response.user!.id);
        showSnackbar('Berhasil', 'Anda berhasil login!');
        Get.offAllNamed(AppRoutes.HOME);
      }
    } on AuthException catch (e) {
      showSnackbar('Error', e.message, isError: true);
    } catch (e) {
      showSnackbar('Error', 'Terjadi kesalahan: $e', isError: true);
    } finally {
      isLoading.value = false;
      hideLoading();
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    showLoading();
    try {
      await supabase.auth.signOut();
      showSnackbar('Berhasil', 'Anda berhasil logout!');
      _box.remove('user_name');
      currentUserName?.value = '';
      Get.offAllNamed(AppRoutes.LOGIN);
    } on AuthException catch (e) {
      showSnackbar('Error', e.message, isError: true);
    } catch (e) {
      showSnackbar('Error', 'Terjadi kesalahan saat logout: $e', isError: true);
    } finally {
      isLoading.value = false;
      hideLoading();
    }
  }
}