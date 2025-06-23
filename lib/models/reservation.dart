class Reservation {
  final String id;
  final String userId;
  final String serviceId;
  final DateTime reservationDate;
  final String reservationTime;
  final String status;
  final String vehicleType;
  final String vehiclePlatNumber;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.reservationDate,
    required this.reservationTime,
    required this.status,
    required this.vehicleType,
    required this.vehiclePlatNumber,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      reservationDate: DateTime.parse(json['reservation_date'] as String),
      reservationTime: json['reservation_time'] as String,
      status: json['status'] as String,
      vehicleType: json['vehicle_type'] as String,
      vehiclePlatNumber: json['vehicle_plat_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'reservation_date': reservationDate.toIso8601String().split('T').first,
      'reservation_time': reservationTime,
      'status': status,
      'vehicle_type': vehicleType,
      'vehicle_plat_number': vehiclePlatNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }
}