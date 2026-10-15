import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/admin_widgets.dart';
import '../../core/widgets/common.dart';
import '../../data/models/restaurant.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nav_provider.dart';
import '../../providers/promo_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../partner/register_restaurant_screen.dart';
import 'admin_availability_screen.dart';
 
/// Profil Admin Restoran (mitra). Sengaja bergaya BERBEDA dari profil customer:
/// header gelap penuh dengan statistik toko, lalu daftar menu pengelolaan.
class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});
 
  Widget _miniStat(String v, String l) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white.withAlpha(30), borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text(v, style: ts(18, w: FontWeight.w800, c: Colors.white)),
            Text(l, style: ts(10, c: Colors.white70)),
          ]),
        ),
      );
 
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final rp = context.watch<RestaurantProvider>();
    final pp = context.watch<PromoProvider>();
    final nav = context.read<NavProvider>();
    final mine = rp.ownedBy(user?.name ?? '');
    final main = mine.isEmpty ? null : mine.first;
    final activePromo = pp.running.where((p) => p.restaurantId == 'r1').length;
 
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EF),
      body: ListView(padding: EdgeInsets.zero, children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF2B1308), AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
              child: Column(children: [
                Row(children: [
                  Text('PROFIL MITRA', style: ts(11, w: FontWeight.w800, c: Colors.white70)),
                  const Spacer(),
                  IconButton(
                      onPressed: () => toast(context, 'Pengaturan segera hadir'),
                      icon: const Icon(Icons.settings_outlined, color: Colors.white)),
                ]),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: const AppLogo(size: 56),
                  ),
                  gapW(14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(main?.name ?? 'Warung Anda',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ts(19, w: FontWeight.w800, c: Colors.white, h: 1.2)),
                      gap(2),
                      Text('Pengelola: ${user?.name ?? '-'}', style: ts(12, c: Colors.white70)),
                      gap(6),
                      const Wrap(spacing: 6, children: [
                        Pill(text: 'Buka Operasional', bg: AppColors.green, fg: Colors.white, fontSize: 10),
                        Pill(text: 'Admin Restoran', bg: AppColors.amber, fg: Color(0xFF4A2F00), fontSize: 10),
                      ]),
                    ]),
                  ),
                ]),
                gap(18),
                Row(children: [
                  _miniStat('${main?.totalTables ?? 0}', 'Meja'),
                  gapW(8),
                  _miniStat('${main?.rating ?? 0}', 'Rating'),
                  gapW(8),
                  _miniStat('$activePromo', 'Promo aktif'),
                ]),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('WARUNG SAYA', style: ts(11, w: FontWeight.w800, c: AppColors.muted)),
            gap(8),
            ...mine.map((r) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: box(color: Colors.white, r: 16),
                  child: Row(children: [
                    FoodImage(path: r.image, width: 54, height: 54, radius: 12),
                    gapW(12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(14, w: FontWeight.w800)),
                        Text('${r.totalTables} meja • ${r.hours}', style: ts(11, c: AppColors.muted)),
                      ]),
                    ),
                    Pill(
                        text: r.status == RestaurantStatus.approved ? 'Aktif' : 'Menunggu persetujuan',
                        bg: r.status == RestaurantStatus.approved ? AppColors.greenSoft : AppColors.amberSoft,
                        fg: r.status == RestaurantStatus.approved ? AppColors.green : const Color(0xFF6B4400),
                        fontSize: 9),
                  ]),
                )),
            gap(10),
            Text('PENGELOLAAN', style: ts(11, w: FontWeight.w800, c: AppColors.muted)),
            gap(8),
            ActionTile(
                icon: Icons.add_business_rounded,
                title: 'Tambah Warung Baru',
                subtitle: 'Jumlah meja, jam buka, harga, fasilitas',
                color: AppColors.green,
                onTap: () => openRegisterRestaurant(context)),
            ActionTile(
                icon: Icons.event_busy_rounded,
                title: 'Atur Ketersediaan Tanggal',
                subtitle: 'Kunci tanggal penuh & lihat tanggal dipesan klien',
                color: AppColors.red,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminAvailabilityScreen()))),
            ActionTile(
                icon: Icons.local_offer_rounded,
                title: 'Kelola Diskon & Promo',
                subtitle: 'Ramadan, Natal, Imlek, Valentine, Hari Raya',
                color: AppColors.primary,
                onTap: () => nav.go(3)),
            ActionTile(
                icon: Icons.receipt_long_rounded,
                title: 'Reservasi Masuk',
                subtitle: 'Setujui atau tolak pesanan meja',
                color: const Color(0xFF4C6EF5),
                onTap: () => nav.go(1)),
            ActionTile(
                icon: Icons.restaurant_menu_rounded,
                title: 'Katalog Menu',
                subtitle: 'Tambah, ubah, atau habiskan stok menu',
                color: AppColors.amber,
                onTap: () => nav.go(2)),
            ActionTile(
                icon: Icons.support_agent_rounded,
                title: 'Bantuan Mitra',
                subtitle: 'Hubungi tim MakanKuy',
                color: AppColors.muted,
                onTap: () => toast(context, 'Segera hadir')),
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