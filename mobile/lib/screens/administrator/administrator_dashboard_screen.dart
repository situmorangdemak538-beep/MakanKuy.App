import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/admin_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/admin_widgets.dart';
import '../../core/widgets/common.dart';
import '../../providers/nav_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/system_provider.dart';
import '../partner/register_restaurant_screen.dart';
import 'administrator_categories_screen.dart';
import 'administrator_monitor_screen.dart';
import 'administrator_restaurants_screen.dart';
import 'administrator_shell.dart';
 
class AdministratorDashboardScreen extends StatelessWidget {
  const AdministratorDashboardScreen({super.key});
 
  static const _bars = [12, 18, 9, 22, 17, 25, 14];
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
 
  Widget _title(String t) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Text(t, style: ts(16, w: FontWeight.w800)),
      );
 
  @override
  Widget build(BuildContext context) {
    final rp = context.watch<RestaurantProvider>();
    final sp = context.watch<SystemProvider>();
    final res = context.watch<ReservationProvider>();
    final nav = context.read<NavProvider>();
 
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: Column(children: [
        const AdministratorHeader(),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                StatBox(icon: Icons.people_alt_rounded, label: 'Total Pengguna', value: '${sp.users.length}', color: AdminColors.indigo),
                StatBox(icon: Icons.storefront_rounded, label: 'Warung Aktif', value: '${rp.all.length}', color: AdminColors.mint),
                StatBox(icon: Icons.pending_actions_rounded, label: 'Menunggu Persetujuan', value: '${rp.pending.length}', color: AppColors.amber),
                StatBox(icon: Icons.receipt_long_rounded, label: 'Total Reservasi', value: '${res.everything.length}', color: AppColors.primary),
              ],
            ),
            _title('Perlu Tindakan'),
            if (rp.pending.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: box(color: Colors.white, r: 18),
                child: Text('Tidak ada pendaftaran warung yang menunggu.', style: ts(12, c: AppColors.muted)),
              ),
            ...rp.pending.take(2).map((r) => PendingRestaurantCard(restaurant: r)),
            if (rp.pending.length > 2)
              TextButton(
                  onPressed: () => nav.go(1),
                  child: Text('Lihat semua (${rp.pending.length})',
                      style: ts(13, w: FontWeight.w800, c: AdminColors.indigo))),
            _title('Reservasi 7 Hari Terakhir (semua restoran)'),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(color: Colors.white, r: 18),
              child: SizedBox(
                height: 120,
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  for (var i = 0; i < _bars.length; i++)
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text('${_bars[i]}', style: ts(10, w: FontWeight.w700)),
                        gap(2),
                        Container(
                          height: _bars[i] * 3.0,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: i == 5 ? AdminColors.indigo : AdminColors.indigoSoft,
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        gap(4),
                        Text(_days[i], style: ts(10, c: AppColors.muted)),
                      ]),
                    ),
                ]),
              ),
            ),
            _title('Akses Cepat'),
            ActionTile(
                icon: Icons.add_business_rounded,
                title: 'Tambah Warung Baru',
                subtitle: 'Langsung aktif tanpa persetujuan',
                color: AdminColors.mint,
                onTap: () => openRegisterRestaurant(context)),
            ActionTile(
                icon: Icons.category_rounded,
                title: 'Kelola Kategori Masakan',
                subtitle: '${sp.categories.length} kategori terdaftar',
                color: AdminColors.indigo,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdministratorCategoriesScreen()))),
            ActionTile(
                icon: Icons.monitor_heart_rounded,
                title: 'Monitoring Semua Reservasi',
                subtitle: 'Lintas restoran, semua status',
                color: AppColors.primary,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdministratorMonitorScreen()))),
            ActionTile(
                icon: Icons.local_offer_rounded,
                title: 'Kelola Promo Pusat',
                subtitle: 'Ramadan, Natal, Imlek, Valentine, Hari Raya',
                color: const Color(0xFFD6336C),
                onTap: () => nav.go(3)),
            _title('Aktivitas Sistem'),
            for (final a in const [
              ('Admin Gamalama menyetujui reservasi MK-TRN-8810', '5 mnt lalu'),
              ('Pendaftaran warung baru: Kedai Kopi Salero', '1 jam lalu'),
              ('Promo "Diskon Meja 25%" diklaim 22 kali', 'Hari ini'),
              ('Akun Pak Dedy Ternate diblokir', 'Kemarin'),
            ])
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: box(color: Colors.white, r: 14),
                child: Row(children: [
                  const Icon(Icons.circle, size: 8, color: AdminColors.indigo),
                  gapW(10),
                  Expanded(child: Text(a.$1, style: ts(12))),
                  Text(a.$2, style: ts(10, c: AppColors.muted)),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }
}