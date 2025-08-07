import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/dashboard/Viewmodels/dashboard_viewmodel.dart';
import 'package:teacher_portal/dashboard/views/custom_drawer.dart';
import 'package:teacher_portal/dashboard/views/dashboard_view.dart';
import 'package:teacher_portal/dashboard/views/main_page_view.dart';
import 'package:teacher_portal/dashboard/views/notifications_view.dart';
import 'package:teacher_portal/dashboard/views/profile_view.dart';
import 'package:teacher_portal/l10n/LocaleProvider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  List<Widget> get _widgetOptions => <Widget>[
    const MainPageView(),
    ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: const DashboardView(),
    ),
    const ProfileView(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<String> _appBarTitles = <String>[
    'Home',
    'Dashboard',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),

      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: "Change Language",
            onPressed: () {
              context.read<LocaleProvider>().toggleLocale();
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsView(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
            tooltip: "Notifications",
          ),
          IconButton(
            onPressed: () {
              _onItemTapped(2); 
            },
            icon: const CircleAvatar(child: Icon(Icons.person)),
            tooltip: "Profile",
          ),

          const SizedBox(width: 10),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
