import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:makankuy/providers/restaurant_provider.dart';
import 'package:makankuy/screens/restaurant_detail_screen.dart';
import 'package:makankuy/utils/colors.dart';
import 'package:makankuy/widgets/restaurant_card.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final controller = TextEditingController();
  String category = 'Semua';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final results = provider.search(controller.text).where((restaurant) {
      return category == 'Semua' || restaurant.category == category;
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
        children: [
          const Text(
            'Pencarian & Filter',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Cari restoran berdasarkan nama, kategori, atau lokasi.',
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari restoran...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  controller.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip('Semua'),
              _chip('Seafood'),
              _chip('Nusantara'),
              _chip('Kedai'),
            ],
          ),
          const SizedBox(height: 20),
          ...results.map(
            (restaurant) => RestaurantCard(
              restaurant: restaurant,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RestaurantDetailScreen(restaurant: restaurant),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String value) {
    return ChoiceChip(
      label: Text(value),
      selected: category == value,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: category == value ? Colors.white : AppColors.dark,
      ),
      onSelected: (_) => setState(() => category = value),
    );
  }
}