import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teacher_portal/database/db_helper.dart';
import 'package:teacher_portal/database/models/user_model.dart';

class UserService {
  final storage = FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    return await DBHelper.instance.checkUser(username, password);
  }

  Future<String?> register(Users user) async {
    final exists = await DBHelper.instance.isUsernameExists(user.username);
    if (exists) return "اسم المستخدم مستخدم بالفعل";
    await DBHelper.instance.addUser(user);
    return null;
  }

  Future<void> saveCredentials(
    String username,
    String password,
    int userId,
  ) async {
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'userId', value: userId.toString());
  }

  Future<Map<String, String?>> getCredentials() async {
    final username = await storage.read(key: 'username');
    final password = await storage.read(key: 'password');
    final userId = await storage.read(key: 'userId');
    return {'username': username, 'password': password, 'userId': userId};
  }

  Future<Users?> getUserByUsername(String username) async {
    return await DBHelper.instance.getUserByUsername(username);
  }

  Future<Users?> getUserById(int userId) async {
    return await DBHelper.instance.getUserById(userId);
  }
}
