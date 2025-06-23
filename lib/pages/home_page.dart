import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../routes/app_routes.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan AuthController dan HomeController terinisialisasi
    if (Get.find<AuthController>() == null) Get.put(AuthController());
    if (Get.find<HomeController>() == null) Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservasi Cuci Kendaraan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchReservations(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthController>().signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Halo, ${controller.userName.value.isEmpty ? 'Pengguna' : controller.userName.value}',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      Get.find<AuthController>().currentUser?.email ??
                          'Tidak ada Email',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Get.back(); // Close drawer
                // Already on home, no need to navigate
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Saya'),
              onTap: () {
                Get.back(); // Close drawer
                Get.toNamed(AppRoutes.PROFILE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Get.back(); // Close drawer
                Get.find<AuthController>().signOut();
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reservations.isEmpty) {
          return const Center(
            child: Text('Belum ada reservasi. Buat reservasi pertama Anda!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.reservations.length,
          itemBuilder: (context, index) {
            final reservation = controller.reservations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jenis Kendaraan: ${reservation.vehicleType}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Plat Nomor: ${reservation.vehiclePlatNumber}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tanggal & Waktu: ${controller.formatReservationDateTime(reservation.reservationDate, reservation.reservationTime)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${reservation.status.capitalizeFirst}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: reservation.status == 'pending'
                            ? Colors.orange
                            : reservation.status == 'confirmed'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.NEW_RESERVATION);
        },
        label: const Text('Reservasi Baru'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
