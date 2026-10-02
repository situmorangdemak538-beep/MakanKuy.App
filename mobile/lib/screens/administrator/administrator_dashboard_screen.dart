import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class AdministratorDashboardScreen
    extends StatelessWidget {
  const AdministratorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Dashboard Administrator',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kelola pengguna, kategori, restoran, dan reservasi sistem.',
          ),
          const SizedBox(height: 20),
          _item(
            context,
            'Manajemen Pengguna',
            Icons.people,
            AppRoutes.userManagement,
          ),
          _item(
            context,
            'Manajemen Kategori',
            Icons.category,
            AppRoutes.categoryManagement,
          ),
          _item(
            context,
            'Persetujuan Restoran',
            Icons.approval,
            AppRoutes.restaurantApproval,
          ),
          _item(
            context,
            'Monitoring Reservasi',
            Icons.monitor,
            AppRoutes.reservationMonitoring,
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 17),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}