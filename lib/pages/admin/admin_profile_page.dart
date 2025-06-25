import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';

class AdminProfilePage extends GetView<ProfileController> {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final AuthController authController = Get.find<AuthController>();

    if (!authController.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
        Get.snackbar('Akses Ditolak', 'Anda tidak memiliki izin admin.');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Admin')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.userProfile.value;
        if (profile == null) {
          return const Center(child: Text('Gagal memuat data profil.'));
        }

        fullNameController.text = profile.fullName;
        usernameController.text = profile.username;
        phoneNumberController.text = profile.phoneNumber;
        final userEmail = authController.currentUser.value?.email ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    backgroundImage:
                        (profile.avatarUrl != null &&
                            profile.avatarUrl!.isNotEmpty)
                        ? NetworkImage(profile.avatarUrl!) as ImageProvider
                        : null,
                    child:
                        (profile.avatarUrl == null ||
                            profile.avatarUrl!.isEmpty)
                        ? Icon(Icons.person, size: 80, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Obx(
                      () => controller.isUploadingAvatar.value
                          ? CircularProgressIndicator(color: Colors.blueAccent)
                          : IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.blueAccent,
                                size: 30,
                              ),
                              onPressed: () => controller.uploadAvatar(),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: userEmail),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateProfile(
                      usernameController.text,
                      fullNameController.text,
                      phoneNumberController.text,
                    );
                  },
                  child: const Text('Perbarui Profil'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
