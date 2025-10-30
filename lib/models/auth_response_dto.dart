class AuthResponseDto {
  final String token;
  final String email;
  final String role;

  AuthResponseDto({
    required this.token,
    required this.email,
    required this.role,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
