import '../../database/database.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final storage = FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    return await DatabaseHelper.instance.checkUser(username, password);
  }

  Future<String?> register(Users user) async {
    bool exists = await DatabaseHelper.instance.isUsernameExit(user.username);
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

  Future<void> saveCredentials(String username, String password) async {
    await Future.wait([
      storage.write(key: 'username', value: username),
      storage.write(key: 'password', value: password),
    ]);
  }

  Future<Map<String, String?>> getCredentials(
    String username,
    String password,
  ) async {
    final values = await Future.wait([
      storage.read(key: 'username'),
      storage.read(key: 'password'),
    ]);
    return {'username': values[0], 'password': values[1]};
  }
}
