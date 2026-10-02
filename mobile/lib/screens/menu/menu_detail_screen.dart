import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class MenuDetailScreen extends StatelessWidget {
  const MenuDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.fastfood,
              size: 90,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nasi Ayam Rempah',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rp25.000',
            style: TextStyle(
              fontSize: 19,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nasi dengan ayam dan bumbu rempah khas. '
            'Menu ini merupakan salah satu menu populer restoran.',
          ),
          const SizedBox(height: 18),
          const Text(
            'Kategori: Makanan',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}