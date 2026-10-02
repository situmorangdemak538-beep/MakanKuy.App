import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/restaurant_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _category = '';

  final categories = const [
    'Semua',
    'Nusantara',
    'Seafood',
    'Kedai',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    context.read<RestaurantProvider>().loadRestaurants(
          search: _searchController.text,
          category: _category,
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MakanKuy'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.profile,
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Jelajahi Kuliner Lokal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Temukan restoran dan lakukan reservasi dengan mudah.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _searchController,
              onChanged: (_) => _load(),
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _load,
                  icon: const Icon(Icons.tune),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = categories[index];
                  final selected =
                      (label == 'Semua' && _category.isEmpty) ||
                      label == _category;

                  return CategoryChip(
                    label: label,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        _category =
                            label == 'Semua' ? '' : label;
                      });
                      _load();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (provider.isLoading)
              const SizedBox(
                height: 200,
                child: LoadingWidget(),
              )
            else if (provider.restaurants.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    'Restoran tidak ditemukan.',
                  ),
                ),
              )
            else
              ...provider.restaurants.map(
                (restaurant) => RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.restaurantDetail,
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.restaurantSearch,
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Pencarian Restoran'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Data pada tahap ini masih menggunakan data lokal sementara. '
                'Setelah backend selesai, data akan berasal dari REST API Laravel dan MySQL.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}