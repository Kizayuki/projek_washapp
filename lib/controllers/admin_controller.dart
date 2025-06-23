import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_model.dart';
import '../utils/app_routes.dart';

class AdminController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  Rx<AdminUser?> currentAdmin = Rx<AdminUser?>(null);
  RxBool isLoading = false.obs;

  Future<void> adminSignIn(String email, String password) async {
    isLoading.value = true;
    try {
      final List<dynamic> response = await _supabaseClient
          .from('admin')
          .select()
          .eq('email', email)
          .eq('password', password)
          .limit(1);

      if (response.isNotEmpty) {
        currentAdmin.value = AdminUser.fromJson(
          response.first as Map<String, dynamic>,
        );
        Get.snackbar('Berhasil', 'Login Admin berhasil!');
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.snackbar('Error Login Admin', 'Email atau password salah.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan tidak dikenal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> adminSignOut() async {
    currentAdmin.value = null;
    Get.offAllNamed(AppRoutes.adminLogin);
    Get.snackbar('Berhasil', 'Logout Admin berhasil!');
  }

  RxList<AdminUser> adminUsers = <AdminUser>[].obs;
  Future<void> fetchAdminUsers() async {
    try {
      isLoading.value = true;
      final List<dynamic> data = await _supabaseClient.from('admin').select();
      adminUsers.value = data
          .map((json) => AdminUser.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar admin: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAdminUser(Map<String, dynamic> adminData) async {
    try {
      isLoading.value = true;
      final List<dynamic> response = await _supabaseClient
          .from('admin')
          .insert(adminData)
          .select();
      if (response.isNotEmpty) {
        Get.snackbar('Berhasil', 'Admin baru ditambahkan.');
        fetchAdminUsers();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan admin: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAdminUser(
    String id,
    Map<String, dynamic> adminData,
  ) async {
    try {
      isLoading.value = true;
      await _supabaseClient.from('admin').update(adminData).eq('id', id);
      Get.snackbar('Berhasil', 'Data admin diperbarui.');
      fetchAdminUsers();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui admin: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAdminUser(String id) async {
    try {
      isLoading.value = true;
      await _supabaseClient.from('admin').delete().eq('id', id);
      Get.snackbar('Berhasil', 'Admin dihapus.');
      fetchAdminUsers();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus admin: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
