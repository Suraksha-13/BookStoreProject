class UserModel {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String role;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      // Using '??' guarantees that if the key is null or missing, it falls back to an empty string instead of crashing
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user', // Defaults to 'user' if role is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "password": password,
      "role": role,
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? password,
    String? role,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}