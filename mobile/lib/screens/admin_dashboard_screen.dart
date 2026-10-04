import 'package:flutter/material.dart';
import 'package:makankuy/routes/app_routes.dart';
import 'package:makankuy/utils/colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Restoran')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 25),
        children: [
          const Text(
            'MakanKuy Partner',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          const Text(
            'Kelola restoran, menu, dan reservasi.',
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _stat('120', 'Booking'),
              const SizedBox(width: 10),
              _stat('8/10', 'Meja'),
              const SizedBox(width: 10),
              _stat('Rp1.850k', 'Omzet'),
            ],
          ),
          const SizedBox(height: 18),
          _menu(
            context,
            Icons.storefront_outlined,
            'Kelola Restoran',
            AppRoutes.adminRestaurant,
          ),
          _menu(
            context,
            Icons.restaurant_menu,
            'Kelola Katalog Menu',
            AppRoutes.adminMenu,
          ),
          _menu(
            context,
            Icons.event_note,
            'Kelola Reservasi',
            AppRoutes.adminReservation,
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, route),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}