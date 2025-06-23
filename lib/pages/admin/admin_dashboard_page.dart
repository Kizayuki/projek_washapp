import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../utils/app_routes.dart';

class AdminDashboardPage extends GetView<AdminController> {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => controller.adminSignOut(),
            tooltip: 'Logout Admin',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                'Selamat datang, ${controller.currentAdmin.value?.fullName ?? controller.currentAdmin.value?.username ?? 'Admin'}!',
                style: Get.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildDashboardCard(
                    icon: Icons.local_car_wash,
                    title: 'Kelola Layanan',
                    onTap: () => Get.toNamed(AppRoutes.adminManageServices),
                  ),
                  _buildDashboardCard(
                    icon: Icons.receipt_long,
                    title: 'Lihat Reservasi',
                    onTap: () => Get.toNamed(AppRoutes.adminViewReservations),
                  ),
                  _buildDashboardCard(
                    icon: Icons.people,
                    title: 'Kelola Pengguna',
                    onTap: () => Get.toNamed(AppRoutes.adminManageUsers),
                  ),
                  _buildDashboardCard(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () => controller.adminSignOut(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
