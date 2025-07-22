class Users {
  String username;
  String password;
  String fullname;
  String email;
  String phoneNumber;

  Users({
    required this.username,
    required this.password,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      username: map['username'],
      password: map['password'],
      fullname: map['fullname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
