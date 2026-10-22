import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/admin_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/admin_widgets.dart';
import '../../core/widgets/common.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nav_provider.dart';
import '../partner/register_restaurant_screen.dart';
import 'administrator_categories_screen.dart';
import 'administrator_monitor_screen.dart';
 
class AdministratorProfileScreen extends StatelessWidget {
  const AdministratorProfileScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final nav = context.read<NavProvider>();
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: ListView(padding: EdgeInsets.zero, children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [AdminColors.navy, AdminColors.navy2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
              child: Column(children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                      color: AdminColors.indigo,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white24, width: 3)),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 42),
                ),
                gap(12),
                Text(user?.name ?? 'Administrator', style: ts(21, w: FontWeight.w800, c: Colors.white)),
                Text(user?.email ?? '-', style: ts(12, c: Colors.white60)),
                gap(10),
                const Wrap(spacing: 6, children: [
                  Pill(text: 'ADMINISTRATOR', bg: AdminColors.indigo, fg: Colors.white, fontSize: 10),
                  Pill(text: 'Akses Penuh', bg: AdminColors.mint, fg: Colors.white, fontSize: 10),
                ]),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('HAK AKSES', style: ts(11, w: FontWeight.w800, c: AppColors.muted)),
            gap(8),
            Wrap(spacing: 8, runSpacing: 8, children: const [
              Pill(text: 'Setujui warung', bg: AdminColors.indigoSoft, fg: AdminColors.indigo),
              Pill(text: 'Kelola pengguna', bg: AdminColors.indigoSoft, fg: AdminColors.indigo),
              Pill(text: 'Kelola kategori', bg: AdminColors.indigoSoft, fg: AdminColors.indigo),
              Pill(text: 'Promo pusat', bg: AdminColors.indigoSoft, fg: AdminColors.indigo),
              Pill(text: 'Monitoring reservasi', bg: AdminColors.indigoSoft, fg: AdminColors.indigo),
            ]),
            gap(18),
            Text('PENGELOLAAN SISTEM', style: ts(11, w: FontWeight.w800, c: AppColors.muted)),
            gap(8),
            ActionTile(
                icon: Icons.storefront_rounded,
                title: 'Persetujuan Warung',
                subtitle: 'Setujui / tolak pendaftaran mitra',
                color: AdminColors.mint,
                onTap: () => nav.go(1)),
            ActionTile(
                icon: Icons.add_business_rounded,
                title: 'Tambah Warung Baru',
                subtitle: 'Langsung aktif',
                color: AdminColors.indigo,
                onTap: () => openRegisterRestaurant(context)),
            ActionTile(
                icon: Icons.category_rounded,
                title: 'Kategori Masakan',
                subtitle: 'Kelola kategori terpusat',
                color: AdminColors.indigo,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdministratorCategoriesScreen()))),
            ActionTile(
                icon: Icons.monitor_heart_rounded,
                title: 'Monitoring Reservasi',
                subtitle: 'Semua transaksi lintas restoran',
                color: AppColors.primary,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdministratorMonitorScreen()))),
            ActionTile(
                icon: Icons.backup_rounded,
                title: 'Backup & Pengaturan Sistem',
                subtitle: 'Tersambung ke backend (tahap berikutnya)',
                color: AppColors.muted,
                onTap: () => toast(context, 'Akan tersambung ke backend')),
            gap(8),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => logoutToSplash(context),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: Text('Keluar dari Akun', style: ts(14, w: FontWeight.w800, c: AppColors.red)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redSoft,
                    foregroundColor: AppColors.red,
                    elevation: 0,
                    shape: const StadiumBorder()),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}