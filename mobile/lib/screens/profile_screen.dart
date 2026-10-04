import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:makankuy/providers/auth_provider.dart';
import 'package:makankuy/routes/app_routes.dart';
import 'package:makankuy/utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
        children: [
          const Text(
            'Profil Pengguna',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.cream, Colors.white],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 43,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  user?.name ?? 'Pelanggan MakanKuy',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  user?.email ?? 'customer@makankuy.app',
                  style: const TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          _item(
            context,
            Icons.receipt_long_outlined,
            'Riwayat Reservasi',
            () => Navigator.pushNamed(context, AppRoutes.history),
          ),
          _item(
            context,
            Icons.favorite_border,
            'Restoran Favorit',
            () {},
          ),
          _item(
            context,
            Icons.help_outline,
            'Bantuan',
            () {},
          ),
          _item(
            context,
            Icons.logout,
            'Keluar',
            () {
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}