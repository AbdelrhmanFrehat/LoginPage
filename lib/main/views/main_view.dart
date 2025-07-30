import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:teachar_app/authentication/models/user.dart';
import 'package:teachar_app/authentication/services/user.service.dart';
import 'package:teachar_app/authentication/view_models/authentication_view_model.dart';
import 'package:teachar_app/theme_provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  final UserService _userService = UserService();
  final storage = FlutterSecureStorage();

   Users? user;
  @override
  void initState() {
    super.initState();
    this.getuserData();
  }

getuserData() async {
  var userId = await storage.read(key: 'userId');
  print('Raw userId: "$userId"');

  if (userId != null && userId.trim().isNotEmpty) {
    int parsedId = int.parse(userId.trim());
    print('Parsed userId: $parsedId');

    user = await _userService.getUserById(parsedId);

    if (user != null) {
      print(user?.fullname);
    } else {
    }

    setState(() {});
  } else {
  }
}

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home', style: optionStyle),
    Text('Index 1: Business', style: optionStyle),
    Text('Index 2: School', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/teacher.png'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullname ??'who are you',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        user?.email??'ahmad.teacher@example.com',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('الملف الشخصي'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('الإشعارات'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('الوضع الليلي'),
              trailing: Switch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (_) {
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme();
                },
              ),
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('حول التطبيق'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'teachar_app',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.school),
                  children: [const Text('تطبيق لتسهيل إدارة المعلم.')],
                );
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () async {
                final auth = Provider.of<AuthenticationViewModel>(
                  context,
                  listen: false,
                );

                await FirebaseAuth.instance.signOut();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSection(
            title: 'الكورسات',
            icon: 'assets/icons/courses.png',
            items: List.generate(10, (i) => 'كورس ${i + 1}'),
          ),
          const SizedBox(height: 20),
          buildSection(
            title: 'إضافة واجب',
            icon: 'assets/icons/homework.png',
            items: List.generate(6, (i) => 'واجب ${i + 1}'),
          ),
          const SizedBox(height: 20),
          buildSection(
            title: 'إضافة امتحان',
            icon: 'assets/icons/exam.png',
            items: List.generate(4, (i) => 'امتحان ${i + 1}'),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Main'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildSection({
    required String title,
    required String icon,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              icon,
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.error),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    items[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
