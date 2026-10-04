import 'package:flutter/material.dart';
import 'package:makankuy/utils/colors.dart';

class AdminReservationScreen extends StatelessWidget {
  const AdminReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Reservasi')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _reservation('Farhan Abdurrahman', '25 Okt 2026 • 19:00', '4 orang'),
          _reservation('Siti Rahmawati', '26 Okt 2026 • 20:00', '2 orang'),
        ],
      ),
    );
  }

  Widget _reservation(String name, String date, String guests) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                'Pending',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('$date • $guests'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Tolak'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('Setujui'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}