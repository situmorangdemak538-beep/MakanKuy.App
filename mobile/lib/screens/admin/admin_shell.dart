import 'package:flutter/material.dart';
import '../../core/widgets/common.dart';
fitur/tegar
import '../../providers/nav_provider.dart';
import '../../providers/reservation_provider.dart';
import '../shared/promo_manager_screen.dart';

main
import 'admin_dashboard_screen.dart';
import 'admin_menu_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_reservations_screen.dart';
fitur/tegar
 
/// Header khusus Admin Restoran (MakanKuy Partner)

import 'admin_store_screen.dart';

/// Header Antarmuka Admin Restoran (MakanKuy Partner)
main
class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(child: AppLogo(size: 26)),
            ),
            gapW(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'MakanKuy Partner ',
                        style: ts(15, w: FontWeight.bold, c: Colors.black87),
                      ),
                      Pill(
                        text: 'UMKM',
                        bg: Colors.orange.shade50,
                        fg: Colors.deepOrange,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      gapW(4),
                      Text(
                        'RM Gohu Ikan Gamalama • Buka',
                        style: ts(11, c: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
fitur/tegar
 
class AdminShell extends StatelessWidget {


/// Wadah Navigasi Bawah Khusus Admin Restoran
class AdminShell extends StatefulWidget {
main
  const AdminShell({super.key});
 
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const AdminReservationsScreen(),
    const AdminMenuScreen(),
    const AdminStoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
fitur/tegar
      body: IndexedStack(index: nav.index, children: const [
        AdminDashboardScreen(),
        AdminReservationsScreen(),
        AdminMenuScreen(),
        PromoManagerScreen(isAdministrator: false, restaurantId: 'r1', header: AdminHeader()),
        AdminProfileScreen(),
      ]),
      bottomNavigationBar: AppBottomNav(
        index: nav.index,
        onTap: nav.go,
        items: [
          const NavItemData(Icons.bar_chart_rounded, 'Ringkasan'),
          NavItemData(Icons.receipt_long_rounded, 'Reservasi', badge: pending),
          const NavItemData(Icons.restaurant_menu_rounded, 'Menu'),
          const NavItemData(Icons.local_offer_rounded, 'Diskon'),
          const NavItemData(Icons.storefront_outlined, 'Profil'),

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Ringkasan',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.receipt_long_rounded),
            ),
            label: 'Reservasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_rounded),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_rounded),
            label: 'Toko',
          ),
main
        ],
      ),
    );
  }
}