class Service {
  final String id;
  final String name;
  final double price;
  final int durationMinutes;
  final String? description;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['duration_minutes'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration_minutes': durationMinutes,
      'description': description,
    };
  }
}
