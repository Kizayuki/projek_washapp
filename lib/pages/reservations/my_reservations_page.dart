import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/reservation_controller.dart';
import '../../models/reservation_model.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  final ReservationController _reservationController =
      Get.find<ReservationController>();
  final String? userId = Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    if (userId != null) {
      _reservationController.fetchUserReservations(userId!);
    } else {
      Get.snackbar('Error', 'Anda harus login untuk melihat reservasi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservasi Saya')),
      body: Obx(() {
        if (_reservationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_reservationController.userReservations.isEmpty) {
          return const Center(child: Text('Anda belum memiliki reservasi.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _reservationController.userReservations.length,
          itemBuilder: (context, index) {
            final Reservation reservation =
                _reservationController.userReservations[index];
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
                      reservation.service?.name ?? 'Layanan Tidak Dikenal',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tanggal: ${reservation.reservationDate.toIso8601String().split('T')[0]}',
                      style: Get.textTheme.titleMedium,
                    ),
                    Text(
                      'Waktu: ${reservation.reservationTime.substring(0, 5)}',
                      style: Get.textTheme.titleMedium,
                    ),
                    Text(
                      'Jenis Kendaraan: ${reservation.vehicleType ?? '-'}',
                      style: Get.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          reservation.status.capitalizeFirst ?? 'Unknown',
                          style: TextStyle(
                            color: _getStatusColor(reservation.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
