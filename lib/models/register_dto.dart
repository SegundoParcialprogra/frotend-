class RegisterDto {
  final String name;
  final String email;
  final String password;

  RegisterDto({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
  'Nombre': name,
  'Email': email,
  'Password': password,
};

}
