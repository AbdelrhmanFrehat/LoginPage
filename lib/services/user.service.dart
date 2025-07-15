import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_4/database/database.dart';
class Users {
  final int? id;
  String fullname;
  String username;
  String password;
  String email;
  String phoneNumber;
  Users(
      {required this.username,
      required this.password,
      this.id,
      required this.fullname,
      required this.email,required this.phoneNumber});
  factory Users.fromMap(Map<String, dynamic> json) => Users(
        id: json['id'],
        fullname: json['fullname'],
        email: json['email'],
        username: json['username'],
        password: json['password'],
        phoneNumber: json['phoneNumber'],
      );
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "fullname": fullname,
      "email": email,
      'username': username,
      'phoneNumber': phoneNumber,
      'password': password
    };
  }

}

