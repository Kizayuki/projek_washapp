import 'service_model.dart';

class Reservation {
  final String id;
  final String userId;
  final String serviceId;
  final DateTime reservationDate;
  final String reservationTime;
  final String status;
  final String? vehicleType;
  final DateTime createdAt;
  final Service? service;
  final String? userName;

  Reservation({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.reservationDate,
    required this.reservationTime,
    required this.status,
    this.vehicleType,
    required this.createdAt,
    this.service,
    this.userName,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    Service? serviceData;
    if (json['services'] is Map<String, dynamic>) {
      serviceData = Service.fromJson(json['services'] as Map<String, dynamic>);
    }

    String? userNameData;
    if (json['profiles'] is Map<String, dynamic> &&
        json['profiles']['full_name'] != null) {
      userNameData = json['profiles']['full_name'] as String;
    }

    return Reservation(
      id: json['id'] as String,
      userId: json['user_id'] is String
          ? json['user_id'] as String
          : (json['user_id'] as Map<String, dynamic>)['id'] as String,
      serviceId: json['service_id'] is String
          ? json['service_id'] as String
          : (json['service_id'] as Map<String, dynamic>)['id'] as String,
      reservationDate: DateTime.parse(json['reservation_date'] as String),
      reservationTime: json['reservation_time'] as String,
      status: json['status'] as String,
      vehicleType: json['vehicle_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      service: serviceData,
      userName: userNameData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'reservation_date': reservationDate.toIso8601String().split('T')[0],
      'reservation_time': reservationTime,
      'status': status,
      'vehicle_type': vehicleType,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
