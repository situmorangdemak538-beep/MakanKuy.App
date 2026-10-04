import 'package:flutter/material.dart';
import 'package:makankuy/utils/colors.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Seafood', 'Nusantara', 'Kedai', 'Kafe'];

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Masakan')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: categories.length,
        itemBuilder: (_, index) => Card(
          child: ListTile(
            leading: const Icon(Icons.category, color: AppColors.primary),
            title: Text(categories[index]),
            trailing: const Icon(Icons.edit_outlined),
          ),
        ),
      ),
    );
  }
}