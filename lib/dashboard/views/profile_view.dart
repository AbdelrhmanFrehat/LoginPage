import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/dashboard/views/edit_profile_view.dart';
import 'package:teacher_portal/database/models/teacher_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthenticationViewModel>();
    final teacher = authViewModel.teacher;

    return Scaffold(
      body: teacher == null
          ? _buildErrorState()
          : _buildProfileContent(context, authViewModel, teacher),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    AuthenticationViewModel authViewModel,
    Teacher teacher,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  teacher.fullName.isNotEmpty
                      ? teacher.fullName[0].toUpperCase()
                      : 'T',
                  style: TextStyle(fontSize: 40, color: Colors.blue.shade800),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                teacher.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                teacher.email,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                teacher.phone,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Colors.blue),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileView()),
                  );
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.lock_outline, color: Colors.orange),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.purple,
                ),
                title: const Text('Notification Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.1),
            foregroundColor: Colors.red,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            authViewModel.logout(context);
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text("Could not load profile data.", style: TextStyle(fontSize: 18)),
          Text("Please try logging in again."),
        ],
      ),
    );
  }
}
