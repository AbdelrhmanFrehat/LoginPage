import 'package:firebase_auth/firebase_auth.dart';

import '../../database/database.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:id_gen/id_gen_helpers.dart';

class UserService {
  final storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    return await DatabaseHelper.instance.checkUser(email, password);
  }

  Future<String?> register(Users user) async {
    
    bool exists = await DatabaseHelper.instance.isUsernameExit(user.username);
     user.id=genTimeId;
    if (exists) return "Username already exists";
    await DatabaseHelper.instance.addUser(user);
    return null;
  }

  Future<Users?> getUserByUsername(String username) async {
    return await DatabaseHelper.instance.getUserByUsername(username);
  }

  Future<List<Users>> getAllUsers() async {
    final rawUsers = await DatabaseHelper.instance.getUsers();
    return rawUsers.map((e) => Users.fromMap(e.toMap())).toList();
  }

  Future<bool> checkUsernameExists(String username) async {
    return await DatabaseHelper.instance.isUsernameExit(username);
  }
 Future<Users?> getUserById(int userId)async{
   final user= await DatabaseHelper.instance.getUserById(userId);
   return user;
 }
  Future<void> saveCredentials(String username, String password,int userId) async {
    await Future.wait([
      storage.write(key: 'username', value: username),
      storage.write(key: 'password', value: password),
      storage.write(key: 'userId', value: userId.toString()),
    ]);
  }
    
  Future<Map<String, String?>> getCredentials(
    String username,
    String password,
    int userId
  ) async {
    final values = await Future.wait([
      storage.read(key: 'username'),
      storage.read(key: 'password'),
      storage.read(key: 'userId'),
    ]);
    return {'username': values[0], 'password': values[1],'userID':values[2]};
  }
}
