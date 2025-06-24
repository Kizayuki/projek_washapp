import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/service_model.dart';

class AdminManageServicesPage extends GetView<ServiceController> {
  const AdminManageServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServiceController());
    final AuthController authController = Get.find<AuthController>();

    if (!authController.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
        Get.snackbar('Akses Ditolak', 'Anda tidak memiliki izin admin.');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    controller.fetchServices();

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Layanan Cuci')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.services.isEmpty) {
          return const Center(
            child: Text('Belum ada layanan yang ditambahkan.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final Service service = controller.services[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(service.name, style: Get.textTheme.titleMedium),
                subtitle: Text(
                  'Rp ${service.price.toStringAsFixed(0)} - ${service.durationMinutes} menit',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditServiceDialog(context, service),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _showDeleteServiceDialog(context, service.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Tambah Layanan Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Layanan'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga (contoh: 50000)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  durationController.text.isNotEmpty) {
                controller.addService({
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'duration_minutes': int.parse(durationController.text),
                  'description': descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                });
                Get.back();
              } else {
                Get.snackbar(
                  'Peringatan',
                  'Mohon lengkapi semua bidang wajib.',
                );
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showEditServiceDialog(BuildContext context, Service service) {
    final TextEditingController nameController = TextEditingController(
      text: service.name,
    );
    final TextEditingController priceController = TextEditingController(
      text: service.price.toString(),
    );
    final TextEditingController durationController = TextEditingController(
      text: service.durationMinutes.toString(),
    );
    final TextEditingController descriptionController = TextEditingController(
      text: service.description,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Layanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Layanan'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  durationController.text.isNotEmpty) {
                controller.updateService(service.id, {
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'duration_minutes': int.parse(durationController.text),
                  'description': descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                });
                Get.back();
              } else {
                Get.snackbar(
                  'Peringatan',
                  'Mohon lengkapi semua bidang wajib.',
                );
              }
            },
            child: const Text('Perbarui'),
          ),
        ],
      ),
    );
  }

  void _showDeleteServiceDialog(BuildContext context, String serviceId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus layanan ini?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              controller.deleteService(serviceId);
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
