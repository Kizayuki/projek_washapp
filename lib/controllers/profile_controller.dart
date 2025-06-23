import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  Rx<Profile?> userProfile = Rx<Profile?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    isLoading.value = true;
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user != null) {
        final response = await _supabaseClient
            .from('profiles')
            .select('*')
            .eq('id', user.id)
            .single();
        userProfile.value = Profile.fromJson(response as Map<String, dynamic>);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(
    String username,
    String fullName,
    String phoneNumber,
  ) async {
    isLoading.value = true;
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Error', 'Pengguna tidak terautentikasi.');
        return;
      }

      await _supabaseClient
          .from('profiles')
          .update({
            'username': username,
            'full_name': fullName,
            'phone_number': phoneNumber,
            'update_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      Get.snackbar('Berhasil', 'Profil berhasil diperbarui!');
      _loadUserProfile();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
