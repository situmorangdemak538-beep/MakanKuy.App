import 'package:flutter/material.dart';

class ReservationMonitoringScreen extends StatelessWidget {
  const ReservationMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoring Reservasi')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Rumah Makan Gohu Ikan Gamalama'),
            subtitle: Text('4 reservasi hari ini'),
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Dapur Ikan Fufu Dodoku'),
            subtitle: Text('2 reservasi hari ini'),
          ),
        ],
      ),
    );
  }
}