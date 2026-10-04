import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:makankuy/models/restaurant_model.dart';
import 'package:makankuy/providers/restaurant_provider.dart';
import 'package:makankuy/screens/restaurant_detail_screen.dart';
import 'package:makankuy/screens/restaurant_search_screen.dart';
import 'package:makankuy/screens/reservation_history_screen.dart';
import 'package:makankuy/screens/profile_screen.dart';
import 'package:makankuy/utils/colors.dart';
import 'package:makankuy/utils/constants.dart';
import 'package:makankuy/widgets/category_chip.dart';
import 'package:makankuy/widgets/loading_widget.dart';
import 'package:makankuy/widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String category = 'Semua';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<RestaurantProvider>().loadRestaurants(),
    );
  }

  void openRestaurant(RestaurantModel restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      const RestaurantSearchScreen(),
      const ReservationHistoryScreenWrapper(),
      const ProfileScreenWrapper(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.cream,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Reservasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    final provider = context.watch<RestaurantProvider>();
    final data = provider.restaurants.where((restaurant) {
      return category == 'Semua' || restaurant.category == category;
    }).toList();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: provider.loadRestaurants,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Ternate, Maluku Utara',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
                const CircleAvatar(
                  radius: 19,
                  backgroundColor: AppColors.cream,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              readOnly: true,
              onTap: () => setState(() => currentIndex = 1),
              decoration: const InputDecoration(
                hintText: 'Cari restoran, menu, atau lokasi...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.tune),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diskon Meja 25% Hari Ini!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Temukan restoran lokal dan amankan meja tanpa perlu chat manual.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 11),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _category('Semua', Icons.apps),
                  const SizedBox(width: 8),
                  _category('Seafood', Icons.set_meal),
                  const SizedBox(width: 8),
                  _category('Nusantara', Icons.rice_bowl),
                  const SizedBox(width: 8),
                  _category('Kedai', Icons.local_cafe),
                ],
              ),
            ),
            const SizedBox(height: 23),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Restoran UMKM Populer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => currentIndex = 1),
                  child: const Text('Semua'),
                ),
              ],
            ),
            const SizedBox(height: 7),
            if (provider.loading)
              const SizedBox(height: 220, child: LoadingWidget())
            else if (data.isEmpty)
              const Center(child: Text('Restoran tidak ditemukan.'))
            else
              ...data.map(
                (restaurant) => RestaurantCard(
                  restaurant: restaurant,
                  onTap: () => openRestaurant(restaurant),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _category(String label, IconData icon) {
    return CategoryChip(
      label: label,
      icon: icon,
      selected: category == label,
      onTap: () => setState(() => category = label),
    );
  }
}

class ReservationHistoryScreenWrapper extends StatelessWidget {
  const ReservationHistoryScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReservationHistoryScreen();
  }
}

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}