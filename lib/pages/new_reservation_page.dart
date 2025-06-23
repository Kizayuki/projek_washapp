import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservation_controller.dart';
import '../widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class NewReservationPage extends GetView<ReservationController> {
  const NewReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.find<ReservationController>() == null) {
      Get.put(ReservationController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Reservasi Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih Layanan Cuci:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.local_car_wash),
                    labelText: 'Pilih Layanan',
                  ),
                  value: controller.selectedService.value?.id,
                  items: controller.services.map((service) {
                    return DropdownMenuItem<String>(
                      value: service.id,
                      child: Text('${service.name} (Rp${service.price.toStringAsFixed(0)})'),
                    );
                  }).toList(),
                  onChanged: (serviceId) {
                    if (serviceId != null) {
                      controller.selectService(
                          controller.services.firstWhere((s) => s.id == serviceId));
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Pilih Tanggal Reservasi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(
              () => ElevatedButton.icon(
                onPressed: () => controller.pickDate(context),
                icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                label: Text(
                  controller.selectedDate.value == null
                      ? 'Pilih Tanggal'
                      : DateFormat('dd MMMM yyyy').format(controller.selectedDate.value!),
                  style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Pilih Waktu Reservasi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(
              () => ElevatedButton.icon(
                onPressed: () => controller.pickTime(context),
                icon: const Icon(Icons.access_time, color: Colors.blueAccent),
                label: Text(
                  controller.selectedTime.value == null
                      ? 'Pilih Waktu'
                      : controller.selectedTime.value!.format(context),
                  style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: controller.vehicleTypeController,
              labelText: 'Jenis Kendaraan (contoh: Mobil, Motor)',
              prefixIcon: Icons.directions_car,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: controller.vehiclePlatNumberController,
              labelText: 'Nomor Plat Kendaraan (contoh: B 1234 ABC)',
              prefixIcon: Icons.format_list_numbered,
            ),
            const SizedBox(height: 30),

            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.createReservation(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Buat Reservasi',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}