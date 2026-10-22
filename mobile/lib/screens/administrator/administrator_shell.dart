import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/admin_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/nav_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../shared/promo_manager_screen.dart';
import 'administrator_dashboard_screen.dart';
import 'administrator_profile_screen.dart';
import 'administrator_restaurants_screen.dart';
import 'administrator_users_screen.dart';
 
class AdministratorHeader extends StatelessWidget {
  final String title, subtitle;
  const AdministratorHeader(
      {super.key,
      this.title = 'Panel Administrator',
      this.subtitle = 'MakanKuy • Pusat Kendali'});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [AdminColors.navy, AdminColors.navy2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 16),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: AdminColors.indigo, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.shield_rounded, color: Colors.white),
            ),
            gapW(12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: ts(17, w: FontWeight.w800, c: Colors.white)),
                Text(subtitle, style: ts(11, c: Colors.white60)),
              ]),
            ),
            IconButton(
                onPressed: () => toast(context, 'Tidak ada notifikasi sistem baru'),
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white)),
          ]),
        ),
      ),
    );
  }
}
 
class AdministratorShell extends StatelessWidget {
  const AdministratorShell({super.key});
 
  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    final pending = context.watch<RestaurantProvider>().pending.length;
    return Scaffold(
      body: IndexedStack(index: nav.index, children: const [
        AdministratorDashboardScreen(),
        AdministratorRestaurantsScreen(),
        AdministratorUsersScreen(),
        PromoManagerScreen(
            isAdministrator: true,
            header: AdministratorHeader(
                title: 'Diskon & Promo Pusat',
                subtitle: 'Kelola promo untuk semua restoran')),
        AdministratorProfileScreen(),
      ]),
      bottomNavigationBar: _Nav(index: nav.index, badge: pending, onTap: nav.go),
    );
  }
}
 
class _Nav extends StatelessWidget {
  final int index, badge;
  final ValueChanged<int> onTap;
  const _Nav({required this.index, required this.badge, required this.onTap});
 
  static const _items = [
    (Icons.dashboard_rounded, 'Ringkasan'),
    (Icons.storefront_rounded, 'Warung'),
    (Icons.people_alt_rounded, 'Pengguna'),
    (Icons.local_offer_rounded, 'Promo'),
    (Icons.shield_rounded, 'Profil'),
  ];
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AdminColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(_items.length, (i) {
              final sel = i == index;
              final c = sel ? Colors.white : Colors.white54;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          color: sel ? AdminColors.indigo : Colors.transparent,
                          borderRadius: BorderRadius.circular(14)),
                      child: Badge(
                        isLabelVisible: i == 1 && badge > 0,
                        label: Text('$badge'),
                        child: Icon(_items[i].$1, color: c, size: 22),
                      ),
                    ),
                    gap(2),
                    Text(_items[i].$2, style: ts(10, w: FontWeight.w700, c: c)),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}