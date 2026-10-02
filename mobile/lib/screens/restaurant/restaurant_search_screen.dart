import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/restaurant_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/restaurant_card.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() =>
      _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState
    extends State<RestaurantSearchScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurants();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Restoran')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              onChanged: (value) {
                provider.loadRestaurants(
                  search: value,
                );
              },
              decoration: const InputDecoration(
                hintText: 'Nama atau alamat restoran',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: provider.restaurants
                          .map(
                            (restaurant) => RestaurantCard(
                              restaurant: restaurant,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.restaurantDetail,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}