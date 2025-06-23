import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/service.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';

class ReservationController extends GetxController {
  final RxList<Service> services = <Service>[].obs;
  RxBool isLoading = true.obs;
  Rx<Service?> selectedService = Rx<Service?>(null);
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController vehiclePlatNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      final data = await supabase.from('services').select('*').order('name', ascending: true);
      if (data != null) {
        services.value = (data as List).map((json) => Service.fromJson(json)).toList();
      }
    } catch (e) {
      showSnackbar('Error', 'Gagal memuat layanan: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void selectService(Service service) {
    selectedService.value = service;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
    }
  }

  String? validateFields() {
    if (selectedService.value == null) {
      return 'Harap pilih layanan.';
    }
    if (selectedDate.value == null) {
      return 'Harap pilih tanggal reservasi.';
    }
    if (selectedTime.value == null) {
      return 'Harap pilih waktu reservasi.';
    }
    if (vehicleTypeController.text.trim().isEmpty) {
      return 'Harap masukkan jenis kendaraan.';
    }
    if (vehiclePlatNumberController.text.trim().isEmpty) {
      return 'Harap masukkan nomor plat kendaraan.';
    }
    return null;
  }

  Future<void> createReservation() async {
    final validationError = validateFields();
    if (validationError != null) {
      showSnackbar('Validasi', validationError, isError: true);
      return;
    }

    showLoading();
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        showSnackbar('Error', 'Pengguna tidak terautentikasi.', isError: true);
        return;
      }

      final reservationTimeFormatted =
          '${selectedTime.value!.hour.toString().padLeft(2, '0')}:${selectedTime.value!.minute.toString().padLeft(2, '0')}';

      await supabase.from('reservations').insert({
        'user_id': userId,
        'service_id': selectedService.value!.id,
        'reservation_date': selectedDate.value!.toIso8601String().split('T').first,
        'reservation_time': reservationTimeFormatted,
        'status': 'pending',
        'vehicle_type': vehicleTypeController.text.trim(),
        'vehicle_plat_number': vehiclePlatNumberController.text.trim(),
      });

      showSnackbar('Berhasil', 'Reservasi berhasil dibuat!');
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      showSnackbar('Error', 'Gagal membuat reservasi: $e', isError: true);
    } finally {
      hideLoading();
    }
  }
}