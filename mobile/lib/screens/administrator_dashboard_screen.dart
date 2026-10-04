import 'package:flutter/material.dart';
import 'package:makankuy/routes/app_routes.dart';
import 'package:makankuy/utils/colors.dart';

class AdministratorDashboardScreen extends StatelessWidget {
  const AdministratorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrator')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Dashboard Administrator',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 7),
          const Text(
            'Kelola pengguna, kategori, restoran, dan monitoring sistem.',
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          _item(context, 'Kelola Pengguna', Icons.people_outline, AppRoutes.users),
          _item(context, 'Kelola Kategori', Icons.category_outlined, AppRoutes.categories),
          _item(context, 'Approval Restoran', Icons.verified_outlined, AppRoutes.approvals),
          _item(context, 'Monitoring Reservasi', Icons.monitor_outlined, AppRoutes.monitoring),
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