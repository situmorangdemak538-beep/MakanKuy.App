import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/nav_provider.dart';
import '../../providers/reservation_provider.dart';
import 'admin_dashboard_screen.dart';
import 'admin_menu_screen.dart';
import 'admin_reservations_screen.dart';
import 'admin_store_screen.dart';

/// Header khusus Admin Restoran (MakanKuy Partner)
class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Row(children: [
          Container(
            width: 46,
            height: 36,
            decoration: box(color: Colors.white, r: 10, border: AppColors.border),
            child: const Center(child: AppLogo(size: 26)),
          ),
          gapW(10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('MakanKuy Partner', style: ts(15, w: FontWeight.w800)),
                gapW(6),
                const Pill(text: 'UMKM', bg: AppColors.primary, fg: Colors.white, fontSize: 9),
              ]),
              Row(children: [
                const Icon(Icons.circle, size: 8, color: AppColors.green),
                gapW(4),
                Text('RM Gohu Ikan Gamalama • Buka',
                    style: ts(11, w: FontWeight.w700, c: AppColors.green)),
              ]),
            ]),
          ),
          Stack(children: [
            IconButton(
                onPressed: () => toast(context, 'Tidak ada notifikasi baru'),
                icon: const Icon(Icons.notifications_none_rounded)),
            const Positioned(
                right: 10,
                top: 10,
                child: Icon(Icons.circle, size: 9, color: AppColors.primary)),
          ]),
          const Avatar(size: 38),
        ]),
      ),
    );
  }
}

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    final pending = context.watch<ReservationProvider>().pending.length;
    return Scaffold(
      body: IndexedStack(index: nav.index, children: const [
        AdminDashboardScreen(),
        AdminReservationsScreen(),
        AdminMenuScreen(),
        AdminStoreScreen(),
      ]),
      bottomNavigationBar: AppBottomNav(
        index: nav.index,
        onTap: nav.go,
        items: [
          const NavItemData(Icons.bar_chart_rounded, 'Ringkasan'),
          NavItemData(Icons.receipt_long_rounded, 'Reservasi', badge: pending),
          const NavItemData(Icons.restaurant_menu_rounded, 'Menu'),
          const NavItemData(Icons.storefront_outlined, 'Toko'),
        ],
      ),
    );
  }
}