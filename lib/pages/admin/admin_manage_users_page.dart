import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/profile_model.dart';

class AdminManageUsersPage extends StatefulWidget {
  const AdminManageUsersPage({super.key});

  @override
  State<AdminManageUsersPage> createState() => _AdminManageUsersPageState();
}

class _AdminManageUsersPageState extends State<AdminManageUsersPage> {
  final AdminController _adminController = Get.find<AdminController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    if (!_authController.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
        Get.snackbar('Akses Ditolak', 'Anda tidak memiliki izin admin.');
      });
    } else {
      _adminController.fetchAppUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authController.isAdmin) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Pengguna Aplikasi')),
      body: Obx(() {
        if (_adminController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_adminController.appUsers.isEmpty) {
          return const Center(child: Text('Belum ada pengguna aplikasi.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _adminController.appUsers.length,
          itemBuilder: (context, index) {
            final Profile user = _adminController.appUsers[index];
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
                  onPressed: () => _showDeleteUserDialog(context, user.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteUserDialog(BuildContext context, String userId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus Pengguna'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus pengguna ini? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              _adminController.deleteAppUser(userId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
