import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_model.dart';

class ServiceController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  RxList<Service> services = <Service>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      final List<dynamic> data = await _supabaseClient
          .from('services')
          .select();
      services.value = data
          .map((json) => Service.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat layanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addService(Map<String, dynamic> serviceData) async {
    try {
      isLoading.value = true;
      final List<dynamic> response = await _supabaseClient
          .from('services')
          .insert(serviceData)
          .select();
      if (response.isNotEmpty) {
        Get.snackbar('Berhasil', 'Layanan baru ditambahkan.');
        fetchServices();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan layanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateService(
    String id,
    Map<String, dynamic> serviceData,
  ) async {
    try {
      isLoading.value = true;
      await _supabaseClient.from('services').update(serviceData).eq('id', id);
      Get.snackbar('Berhasil', 'Layanan diperbarui.');
      fetchServices();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui layanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService(String id) async {
    try {
      isLoading.value = true;
      await _supabaseClient.from('services').delete().eq('id', id);
      Get.snackbar('Berhasil', 'Layanan dihapus.');
      fetchServices();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus layanan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
