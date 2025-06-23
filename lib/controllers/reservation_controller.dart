import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/reservation_model.dart';

class ReservationController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  RxList<Reservation> userReservations = <Reservation>[].obs;
  RxList<Reservation> allReservations = <Reservation>[].obs;
  RxBool isLoading = false.obs;

  Future<void> createReservation(
    String serviceId,
    DateTime reservationDate,
    String reservationTime,
    String vehicleType,
  ) async {
    isLoading.value = true;
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Error', 'Pengguna tidak terautentikasi.');
        return;
      }

      await _supabaseClient.from('reservations').insert({
        'user_id': userId,
        'service_id': serviceId,
        'reservation_date': reservationDate.toIso8601String().split('T')[0],
        'reservation_time': reservationTime,
        'status': 'pending',
        'vehicle_type': vehicleType,
      });
      Get.snackbar('Berhasil', 'Reservasi Anda berhasil dibuat!');
      fetchUserReservations(userId);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat reservasi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserReservations(String userId) async {
    isLoading.value = true;
    try {
      final List<dynamic> data = await _supabaseClient
          .from('reservations')
          .select('*, services(*)')
          .eq('user_id', userId)
          .order('reservation_date', ascending: false)
          .order('reservation_time', ascending: false);
      userReservations.value = data
          .map((json) => Reservation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat reservasi Anda: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllReservations() async {
    isLoading.value = true;
    try {
      final List<dynamic> data = await _supabaseClient
          .from('reservations')
          .select('*, services(*), profiles(full_name)')
          .order('created_at', ascending: false);
      allReservations.value = data
          .map((json) => Reservation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat semua reservasi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateReservationStatus(
    String reservationId,
    String newStatus,
  ) async {
    try {
      await _supabaseClient
          .from('reservations')
          .update({'status': newStatus})
          .eq('id', reservationId);
      Get.snackbar('Berhasil', 'Status reservasi diperbarui.');
      fetchAllReservations();
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId != null) {
        fetchUserReservations(userId);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status reservasi: $e');
    }
  }
}
