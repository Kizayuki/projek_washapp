import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/admin_controller.dart';
import '../../models/profile_model.dart';

class AdminManageUsersPage extends StatefulWidget {
  const AdminManageUsersPage({super.key});

  @override
  State<AdminManageUsersPage> createState() => _AdminManageUsersPageState();
}

class _AdminManageUsersPageState extends State<AdminManageUsersPage> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  RxList<Profile> appUsers = <Profile>[].obs;
  RxBool isLoadingUsers = false.obs;

  @override
  void initState() {
    super.initState();
    _fetchAppUsers();
  }

  Future<void> _fetchAppUsers() async {
    isLoadingUsers.value = true;
    try {
      final List<dynamic> data = await _supabaseClient
          .from('profiles')
          .select();
      appUsers.value = data
          .map((json) => Profile.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar pengguna aplikasi: $e');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> _deleteUser(String userId) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus Pengguna'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus pengguna ini? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _supabaseClient
                    .from('profiles')
                    .delete()
                    .eq('id', userId);
                Get.snackbar(
                  'Berhasil',
                  'Pengguna berhasil dihapus dari profil.',
                );
                _fetchAppUsers();
                Get.back();
              } catch (e) {
                Get.snackbar('Error', 'Gagal menghapus pengguna: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Pengguna Aplikasi')),
      body: Obx(() {
        if (isLoadingUsers.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (appUsers.isEmpty) {
          return const Center(child: Text('Belum ada pengguna aplikasi.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: appUsers.length,
          itemBuilder: (context, index) {
            final Profile user = appUsers[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Colors.blueAccent,
                ),
                title: Text(user.fullName, style: Get.textTheme.titleMedium),
                subtitle: Text('${user.username} | ${user.phoneNumber}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
