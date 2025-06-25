import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/app_routes.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda WashApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => controller.signOut(),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Obx(() {
                final profile = profileController.userProfile.value;
                final userEmail = controller.currentUser.value?.email;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (profile?.avatarUrl != null &&
                              profile!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(profile.avatarUrl!) as ImageProvider
                          : null,
                      child:
                          (profile?.avatarUrl == null ||
                              profile!.avatarUrl!.isEmpty)
                          ? Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue[800],
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile?.fullName ?? 'Pengguna',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userEmail ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.home);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Saya'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_car_wash),
              title: const Text('Daftar Layanan'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.serviceList);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Buat Reservasi'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.reservation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Reservasi Saya'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.myReservations);
              },
            ),
            Obx(
              () => controller.isAdmin
                  ? Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.admin_panel_settings),
                          title: const Text('Dashboard Admin'),
                          onTap: () {
                            Get.back();
                            Get.toNamed(AppRoutes.adminDashboard);
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => controller.signOut(),
            ),
          ],
        ),
      ),
      body: Center(
        child: Obx(() {
          final profile = profileController.userProfile.value;
          if (profileController.isLoading.value) {
            return const CircularProgressIndicator();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile?.fullName != null
                    ? 'Selamat datang, ${profile!.fullName}!'
                    : 'Selamat datang di WashApp!',
                style: Get.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Aplikasi reservasi cuci kendaraan Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Buat Reservasi Sekarang'),
                onPressed: () {
                  Get.toNamed(AppRoutes.reservation);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: const Text('Lihat Reservasi Saya'),
                onPressed: () {
                  Get.toNamed(AppRoutes.myReservations);
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
