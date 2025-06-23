import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/service_controller.dart';
import '../../models/service_model.dart';
import '../../utils/app_routes.dart';

class ServiceListPage extends GetView<ServiceController> {
  const ServiceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServiceController());

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Layanan Cuci')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.services.isEmpty) {
          return const Center(child: Text('Belum ada layanan yang tersedia.'));
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Harga: Rp ${service.price.toStringAsFixed(0)}',
                      style: Get.textTheme.titleMedium,
                    ),
                    Text(
                      'Durasi: ${service.durationMinutes} menit',
                      style: Get.textTheme.bodyLarge,
                    ),
                    if (service.description != null &&
                        service.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          service.description!,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.reservation,
                            arguments: service,
                          );
                        },
                        icon: const Icon(Icons.book),
                        label: const Text('Pesan Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
