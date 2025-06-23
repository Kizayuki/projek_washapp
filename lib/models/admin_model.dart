class AdminUser {
  final String id;
  final String username;
  final String email;
  final String password;
  final String? fullName;
  final DateTime? createdAt;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.fullName,
    this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['full_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'full_name': fullName,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
