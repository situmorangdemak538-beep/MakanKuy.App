import 'package:flutter/material.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends State<CategoryManagementScreen> {
  final categories = <String>[
    'Nusantara',
    'Seafood',
    'Kedai',
  ];

  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _add() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      categories.add(controller.text.trim());
      controller.clear();
    });

    Navigator.pop(context);
  }

  void _showAdd() {
    controller.clear();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tambah Kategori'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nama Kategori',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _add,
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kategori'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAdd,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.category),
              title: Text(categories[index]),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    categories.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
    );
  }
}