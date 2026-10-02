import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              user?.name ?? 'Pelanggan MakanKuy',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              user?.email ?? 'Belum login',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Reservasi'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.reservationHistory,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await context.read<AuthProvider>().logout();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}