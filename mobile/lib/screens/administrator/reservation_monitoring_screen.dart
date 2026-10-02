import 'package:flutter/material.dart';

class ReservationMonitoringScreen
    extends StatelessWidget {
  const ReservationMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Reservasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Belum ada reservasi'),
              subtitle: Text(
                'Reservasi dari seluruh restoran akan ditampilkan di sini.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}