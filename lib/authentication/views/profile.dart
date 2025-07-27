import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import '../services/user.service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
    final UserService _userService = UserService();
      late Future<List<Users>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = _userService.getAllUsers(); // تحميل المستخدمين عند بداية الصفحة
  }
  final FlutterSecureStorage storage = FlutterSecureStorage();

    void logout() async {
      

    Navigator.pushReplacementNamed(context, '/');
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                child: Text("Logout"),
                onPressed:logout,
              ),
            ),
           Expanded(
              child: FutureBuilder<List<Users>>(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("خطأ: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("لا يوجد مستخدمين"));
                  } else {
                    final users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,  
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user.fullname),
                          subtitle: Text(user.email ?? "لا يوجد بريد"),
                        );
                      },
                    );
                  }
                },
              ),
            ),
    
          ],
        ),
      ),
    );
  }
}
