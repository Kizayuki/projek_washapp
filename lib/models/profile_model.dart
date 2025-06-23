class Profile {
  final String id;
  final String username;
  final String fullName;
  final String phoneNumber;
  final String? avatarUrl;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.phoneNumber,
    this.avatarUrl,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      avatarUrl: json['avatar_url'] as String?,
      updatedAt: json['update_at'] != null
          ? DateTime.parse(json['update_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'update_at': updatedAt?.toIso8601String(),
    };
  }
}
