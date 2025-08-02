class Users {
  int? id;
  String username;
  String password;
  String fullname;
  String email;
  String phoneNumber;

  Users({
    required this.id,
    required this.username,
    required this.password,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'],
      username: map['username'],
      password: map['password'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
