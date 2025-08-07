class Teacher {
  final String? id;
  final String fullName;
  final String email;
  final String phone;
  final List<String> fcmTokens; 

  Teacher({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.fcmTokens = const [], 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'fcmTokens': fcmTokens,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map, String id) {
    return Teacher(
      id: id,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      fcmTokens: map['fcmTokens'] != null ? List<String>.from(map['fcmTokens']) : [],
    );
  }

  Teacher copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    List<String>? fcmTokens,
  }) {
    return Teacher(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fcmTokens: fcmTokens ?? this.fcmTokens,
    );
  }
}