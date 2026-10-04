import 'package:flutter/material.dart';
import 'package:makankuy/utils/colors.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final menus = <String>[
    'Gohu Ikan Cakalang Segar',
    'Ikan Bakar Rempah',
    'Nasi Rempah Ayam',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Katalog Menu')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => setState(() => menus.add('Menu Baru')),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: menus.length,
        separatorBuilder: (_, __) => const SizedBox(height: 9),
        itemBuilder: (_, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.cream,
              child: Icon(Icons.fastfood, color: AppColors.primary),
            ),
            title: Text(
              menus[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Rp35.000'),
            trailing: const Icon(Icons.edit_outlined),
          ),
        ),
      ),
    );
  }
}