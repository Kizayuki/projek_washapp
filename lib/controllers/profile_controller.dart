import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  Rx<Profile?> userProfile = Rx<Profile?>(null);
  RxBool isLoading = false.obs;
  RxBool isUploadingAvatar = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadUserProfile(String userId) async {
    isLoading.value = true;
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .single();
      userProfile.value = Profile.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      Get.snackbar('Error Profil', 'Gagal memuat data profil: ${e.message}');
      userProfile.value = null;
    } catch (e) {
      Get.snackbar('Error Profil', 'Gagal memuat data profil (umum): $e');
      userProfile.value = null;
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
      await loadUserProfile(userId);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadAvatar() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image == null) {
      Get.snackbar('Peringatan', 'Tidak ada gambar yang dipilih.');
      return;
    }

    isUploadingAvatar.value = true;
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Error', 'Pengguna tidak terautentikasi.');
        return;
      }

      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.${image.name.split('.').last}';
      final String filePath = '$userId/$fileName'; // Folder berdasarkan user ID

      final File file = File(image.path);
      await _supabaseClient.storage
          .from('avatars')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          ); // Gunakan upsert untuk menimpa jika sudah ada

      final String publicUrl = _supabaseClient.storage
          .from('avatars')
          .getPublicUrl(filePath);

      await _supabaseClient
          .from('profiles')
          .update({
            'avatar_url': publicUrl,
            'update_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      Get.snackbar('Berhasil', 'Foto profil berhasil diperbarui!');
      await loadUserProfile(userId);
    } on StorageException catch (e) {
      Get.snackbar('Error Upload', 'Gagal mengunggah foto: ${e.message}');
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengunggah foto: $e');
    } finally {
      isUploadingAvatar.value = false;
    }
  }
}
