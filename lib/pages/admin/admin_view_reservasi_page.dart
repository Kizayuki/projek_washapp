import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reservation_controller.dart';
import '../../models/reservation_model.dart';

class AdminViewReservationsPage extends StatefulWidget {
  const AdminViewReservationsPage({super.key});

  @override
  State<AdminViewReservationsPage> createState() =>
      _AdminViewReservationsPageState();
}

class _AdminViewReservationsPageState extends State<AdminViewReservationsPage> {
  final ReservationController _reservationController =
      Get.find<ReservationController>();

  @override
  void initState() {
    super.initState();
    _reservationController.fetchAllReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lihat Semua Reservasi')),
      body: Obx(() {
        if (_reservationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_reservationController.allReservations.isEmpty) {
          return const Center(child: Text('Belum ada reservasi yang dibuat.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _reservationController.allReservations.length,
          itemBuilder: (context, index) {
            final Reservation reservation =
                _reservationController.allReservations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                title: Text(
                  reservation.service?.name ?? 'Layanan Tidak Dikenal',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${reservation.reservationDate.toIso8601String().split('T')[0]} - ${reservation.reservationTime.length >= 5 ? reservation.reservationTime.substring(0, 5) : reservation.reservationTime}',
                ),
                trailing: Chip(
                  label: Text(reservation.status.capitalizeFirst ?? 'Unknown'),
                  backgroundColor: _getStatusColor(reservation.status),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Oleh: ${reservation.userName ?? reservation.userId}',
                        ),
                        Text(
                          'Jenis Kendaraan: ${reservation.vehicleType ?? '-'}',
                        ),
                        Text(
                          'Harga: Rp ${reservation.service?.price.toStringAsFixed(0) ?? '-'}',
                        ),
                        Text(
                          'Durasi: ${reservation.service?.durationMinutes ?? '-'} menit',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _reservationController
                                  .updateReservationStatus(
                                    reservation.id,
                                    'confirmed',
                                  ),
                              icon: const Icon(Icons.check),
                              label: const Text('Konfirmasi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _reservationController
                                  .updateReservationStatus(
                                    reservation.id,
                                    'completed',
                                  ),
                              icon: const Icon(Icons.done_all),
                              label: const Text('Selesai'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _reservationController
                                  .updateReservationStatus(
                                    reservation.id,
                                    'cancelled',
                                  ),
                              icon: const Icon(Icons.cancel),
                              label: const Text('Batal'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
