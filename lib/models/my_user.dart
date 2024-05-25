class MyUser {
  final String email;
  final String role;

  MyUser({
    required this.email,
    required this.role,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
    };
  }
}
