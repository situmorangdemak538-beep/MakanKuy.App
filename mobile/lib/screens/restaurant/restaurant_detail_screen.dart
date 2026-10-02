import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../widgets/menu_card.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadMenus(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Restoran'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fitur berbagi akan dihubungkan pada tahap berikutnya.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.restaurant,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'MakanKuy Resto',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 5),
              Text('4.8'),
              SizedBox(width: 18),
              Text('Nusantara'),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Ternate, Maluku Utara',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text('Buka 10:00 - 22:00'),
          const SizedBox(height: 6),
          const Text('Rp25.000 - Rp75.000'),
          const SizedBox(height: 18),
          const Text(
            'Tentang Restoran',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Restoran lokal dengan pilihan makanan yang cocok '
            'untuk keluarga dan teman.',
          ),
          const SizedBox(height: 22),
          const Text(
            'Menu Populer',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (menuProvider.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ...menuProvider.menus.map(
              (menu) => MenuCard(
                menu: menu,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.menuDetail,
                  );
                },
              ),
            ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.reservationForm,
                );
              },
              icon: const Icon(Icons.event_available),
              label: const Text('Reservasi Meja'),
            ),
          ),
        ],
      ),
    );
  }
}