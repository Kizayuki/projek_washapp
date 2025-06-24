import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_model.dart';
import '../models/profile_model.dart';
import 'auth_controller.dart';

class AdminController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthController _authController = Get.find<AuthController>();

  RxBool isLoading = false.obs;

  RxList<Profile> appUsers = <Profile>[].obs;
  Future<void> fetchAppUsers() async {
    if (!_authController.isAdmin) {
      Get.snackbar('Akses Ditolak', 'Anda bukan admin.');
      return;
    }
    try {
      isLoading.value = true;
      final List<dynamic> data = await _supabaseClient
          .from('profiles')
          .select('*');
      appUsers.value = data
          .map((json) => Profile.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar pengguna aplikasi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAppUser(String userId) async {
    if (!_authController.isAdmin) {
      Get.snackbar('Akses Ditolak', 'Anda bukan admin.');
      return;
    }
    try {
      isLoading.value = true;
      await _supabaseClient.from('profiles').delete().eq('id', userId);
      Get.snackbar('Berhasil', 'Pengguna berhasil dihapus dari profil.');
      fetchAppUsers();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus pengguna: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
