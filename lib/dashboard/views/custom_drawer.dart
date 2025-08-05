import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/theme_provider.dart';

class CustomDrawer extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const CustomDrawer({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Sarah Johnson"),
            accountEmail: Text("sarah.j@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ), // Replace with your asset
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            subtitle: Text('Manage your personal information'),
            onTap: () {
              // Handle profile tap
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_6_outlined),
            title: Text('Dark Mode'),
            trailing: Switch(
              value: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (val) {
                context.read<ThemeProvider>().toggleTheme(val);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notifications'),
            subtitle: Text('View real-time alerts'),
            onTap: () {
              // Handle notifications
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('App info and developers'),
            onTap: () {
              // Handle about
            },
          ),
          const Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Provider.of<AuthenticationViewModel>(
                context,
                listen: false,
              ).logout(context);
            },
          ),
        ],
      ),
    );
  }
}
