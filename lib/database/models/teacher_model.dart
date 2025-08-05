class Teacher {
  final String? id; // <<< غيرناه إلى String?
  final String fullName;
  final String email;
  final String phone;

  Teacher({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'fullName': fullName, 'email': email, 'phone': phone};
  }

  factory Teacher.fromMap(Map<String, dynamic> map, String id) {
    return Teacher(
      id: id,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
