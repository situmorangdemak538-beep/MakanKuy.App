import 'package:flutter/material.dart';

import '../../models/menu_model.dart';
import '../../utils/colors.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() =>
      _AdminMenuScreenState();
}

class _AdminMenuScreenState
    extends State<AdminMenuScreen> {
  final List<Menu> menus = [
    const Menu(
      id: 1,
      restaurantId: 1,
      name: 'Nasi Ayam Rempah',
      imageUrl: '',
      price: 25000,
      description: 'Nasi dengan ayam dan bumbu rempah khas.',
      category: 'Makanan',
      isPopular: true,
    ),
    const Menu(
      id: 2,
      restaurantId: 1,
      name: 'Ikan Bakar',
      imageUrl: '',
      price: 40000,
      description: 'Ikan bakar dengan sambal dan pelengkap.',
      category: 'Makanan',
      isPopular: true,
    ),
  ];

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _form({int? index}) {
    if (index == null) {
      nameController.clear();
      priceController.clear();
      descriptionController.clear();
    } else {
      final item = menus[index];
      nameController.text = item.name;
      priceController.text = item.price.toStringAsFixed(0);
      descriptionController.text = item.description;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(index == null ? 'Tambah Menu' : 'Edit Menu'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Menu',
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final price =
                    double.tryParse(priceController.text) ?? 0;

                setState(() {
                  final menu = Menu(
                    id: index == null
                        ? menus.length + 1
                        : menus[index].id,
                    restaurantId: 1,
                    name: nameController.text.trim(),
                    imageUrl: '',
                    price: price,
                    description:
                        descriptionController.text.trim(),
                    category: 'Makanan',
                    isPopular: false,
                  );

                  if (index == null) {
                    menus.add(menu);
                  } else {
                    menus[index] = menu;
                  }
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kelola Menu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _form(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.fastfood),
              ),
              title: Text(menu.name),
              subtitle: Text(
                'Rp ${menu.price.toStringAsFixed(0)}\n${menu.description}',
              ),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _form(index: index);
                  } else {
                    setState(() => menus.removeAt(index));
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}