import 'package:get/get.dart';
import '../models/reservation.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxList<Reservation> reservations = <Reservation>[].obs;
  RxBool isLoading = true.obs;
  RxString userName = ''.obs; // Untuk menampilkan nama user di home

  @override
  void onInit() {
    super.onInit();
    fetchReservations();
    // Mengambil nama pengguna dari AuthController
    if (Get.find<AuthController>().currentUserName?.value != null) {
      userName.value = Get.find<AuthController>().currentUserName!.value;
    }
    // Mendengarkan perubahan nama pengguna dari AuthController
    ever(Get.find<AuthController>().currentUserName!, (String? newName) {
      if (newName != null) {
        userName.value = newName;
      }
    });
  }

  Future<void> fetchReservations() async {
    isLoading.value = true;
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        showSnackbar('Error', 'Pengguna tidak terautentikasi.', isError: true);
        return;
      }

      final data = await supabase
          .from('reservations')
          .select('*')
          .eq('user_id', userId)
          .order('reservation_date', ascending: false)
          .order('reservation_time', ascending: false);

      if (data != null) {
        reservations.value = (data as List)
            .map((json) => Reservation.fromJson(json))
            .toList();
      }
    } catch (e) {
      showSnackbar('Error', 'Gagal memuat reservasi: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  String formatReservationDateTime(DateTime date, String time) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
    return DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }
}