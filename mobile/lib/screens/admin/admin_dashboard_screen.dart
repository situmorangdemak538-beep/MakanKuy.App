import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../utils/colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin Restoran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Dashboard Restoran',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kelola informasi restoran, menu, dan reservasi.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _stat('Restoran', '1', Icons.restaurant),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _stat('Menu', '3', Icons.restaurant_menu),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _stat('Reservasi', '0', Icons.event),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _stat('Menunggu', '0', Icons.pending),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _menu(
            context,
            'Kelola Restoran',
            Icons.restaurant,
            AppRoutes.adminRestaurant,
          ),
          _menu(
            context,
            'Kelola Menu',
            Icons.restaurant_menu,
            AppRoutes.adminMenu,
          ),
          _menu(
            context,
            'Kelola Reservasi',
            Icons.event_note,
            AppRoutes.adminReservation,
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 17),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}