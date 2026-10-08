import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/common.dart';
import '../../providers/nav_provider.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'reservation_history_screen.dart';
import 'search_screen.dart';

class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    return Scaffold(
      body: IndexedStack(index: nav.index, children: const [
        HomeScreen(),
        SearchScreen(),
        ReservationHistoryScreen(),
        ProfileScreen(),
      ]),
      bottomNavigationBar: AppBottomNav(
        index: nav.index,
        onTap: nav.go,
        items: const [
          NavItemData(Icons.restaurant_menu_rounded, 'Beranda'),
          NavItemData(Icons.search_rounded, 'Cari'),
          NavItemData(Icons.receipt_long_rounded, 'Riwayat'),
          NavItemData(Icons.person_outline_rounded, 'Profil'),
        ],
      ),
    );
  }
}