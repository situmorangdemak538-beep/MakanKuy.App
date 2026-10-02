import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/validators.dart';

class AdminRestaurantScreen extends StatefulWidget {
  const AdminRestaurantScreen({super.key});

  @override
  State<AdminRestaurantScreen> createState() =>
      _AdminRestaurantScreenState();
}

class _AdminRestaurantScreenState
    extends State<AdminRestaurantScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController =
      TextEditingController(text: 'MakanKuy Resto');
  final addressController =
      TextEditingController(text: 'Ternate, Maluku Utara');
  final hoursController =
      TextEditingController(text: '10:00 - 22:00');
  final descriptionController = TextEditingController(
    text:
        'Restoran lokal dengan pilihan makanan untuk keluarga dan teman.',
  );

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    hoursController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Informasi restoran disimpan sementara.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kelola Restoran')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Icon(Icons.restaurant, size: 50),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                validator: Validators.validateRequired,
                decoration: const InputDecoration(
                  labelText: 'Nama Restoran',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                validator: Validators.validateRequired,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: hoursController,
                validator: Validators.validateRequired,
                decoration: const InputDecoration(
                  labelText: 'Jam Operasional',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                validator: Validators.validateRequired,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}