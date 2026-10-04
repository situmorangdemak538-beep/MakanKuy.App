import 'package:flutter/material.dart';
import 'package:makankuy/utils/colors.dart';

class AdminRestaurantScreen extends StatefulWidget {
  const AdminRestaurantScreen({super.key});

  @override
  State<AdminRestaurantScreen> createState() => _AdminRestaurantScreenState();
}

class _AdminRestaurantScreenState extends State<AdminRestaurantScreen> {
  final name = TextEditingController(text: 'Rumah Makan Gohu Ikan Gamalama');
  final address = TextEditingController(text: 'Gamalama, Ternate');
  final hours = TextEditingController(text: '10:00 - 22:00 WIT');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Restoran')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _field('Nama Restoran', name),
          _field('Alamat', address),
          _field('Jam Operasional', hours),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data restoran disimpan.')),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Simpan Perubahan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}