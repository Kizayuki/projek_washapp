import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reservation_controller.dart';
import '../../controllers/service_controller.dart';
import '../../models/service_model.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final ReservationController _reservationController =
      Get.find<ReservationController>();
  final ServiceController _serviceController = Get.find<ServiceController>();

  Service? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _vehicleTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Get.arguments is Service) {
      _selectedService = Get.arguments as Service;
    }
    if (_serviceController.services.isEmpty) {
      _serviceController.fetchServices();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitReservation() {
    if (_selectedService == null) {
      Get.snackbar('Peringatan', 'Mohon pilih layanan.');
      return;
    }
    if (_selectedDate == null) {
      Get.snackbar('Peringatan', 'Mohon pilih tanggal reservasi.');
      return;
    }
    if (_selectedTime == null) {
      Get.snackbar('Peringatan', 'Mohon pilih waktu reservasi.');
      return;
    }
    if (_vehicleTypeController.text.trim().isEmpty) {
      Get.snackbar('Peringatan', 'Mohon masukkan jenis kendaraan Anda.');
      return;
    }

    final String timeString =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00';

    _reservationController.createReservation(
      _selectedService!.id,
      _selectedDate!,
      timeString,
      _vehicleTypeController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Reservasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Layanan Cuci', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            Obx(() {
              if (_serviceController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_serviceController.services.isEmpty) {
                return const Text('Tidak ada layanan tersedia.');
              }
              return DropdownButtonFormField<Service>(
                value: _selectedService,
                decoration: const InputDecoration(
                  labelText: 'Layanan',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Pilih layanan...'),
                onChanged: (Service? newValue) {
                  setState(() {
                    _selectedService = newValue;
                  });
                },
                items: _serviceController.services.map<DropdownMenuItem<Service>>((
                  Service service,
                ) {
                  return DropdownMenuItem<Service>(
                    value: service,
                    child: Text(
                      '${service.name} (Rp ${service.price.toStringAsFixed(0)})',
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),
            Text('Detail Reservasi', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Reservasi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                baseStyle: Get.textTheme.bodyLarge,
                child: Text(
                  _selectedDate == null
                      ? 'Pilih Tanggal'
                      : _selectedDate!.toIso8601String().split('T')[0],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Waktu Reservasi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                baseStyle: Get.textTheme.bodyLarge,
                child: Text(
                  _selectedTime == null
                      ? 'Pilih Waktu'
                      : _selectedTime!.format(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _vehicleTypeController,
              decoration: const InputDecoration(
                labelText: 'Jenis Kendaraan (contoh: Sedan, MPV, Motor)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.car_rental),
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => _reservationController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Konfirmasi Reservasi'),
                        onPressed: _submitReservation,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
