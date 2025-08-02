class Teacher {
  final int? id;
  final String fullName;
  final String email;
  final String phone;
  final String password;

  Teacher({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
    );
  }
}
