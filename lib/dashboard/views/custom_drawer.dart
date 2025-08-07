import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/dashboard/views/about_view.dart';
import 'package:teacher_portal/dashboard/views/notifications_view.dart';
import 'package:teacher_portal/theme_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthenticationViewModel>();
    final teacher = authViewModel.teacher;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(teacher?.fullName ?? 'Teacher Name'),
            accountEmail: Text(teacher?.email ?? 'teacher@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                teacher?.fullName.isNotEmpty == true
                    ? teacher!.fullName[0].toUpperCase()
                    : 'T',
                style: const TextStyle(fontSize: 40.0, color: Colors.blue),
              ),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            subtitle: const Text('Manage your personal information'),
            onTap: () {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Profile tab is already in the main view."),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (val) {
                context.read<ThemeProvider>().toggleTheme(val);
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notifications'),
            subtitle: const Text('View real-time alerts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsView()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('App info and developers'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutView()),
              );
            },
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              authViewModel.logout(context);
            },
          ),
        ],
      ),
    );
  }
}
