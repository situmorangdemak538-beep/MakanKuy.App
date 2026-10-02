import 'package:flutter/material.dart';

class RestaurantApprovalScreen extends StatefulWidget {
  const RestaurantApprovalScreen({super.key});

  @override
  State<RestaurantApprovalScreen> createState() =>
      _RestaurantApprovalScreenState();
}

class _RestaurantApprovalScreenState
    extends State<RestaurantApprovalScreen> {
  final restaurants = <Map<String, String>>[
    {
      'name': 'Rasa Bahari',
      'address': 'Ternate, Maluku Utara',
      'status': 'Menunggu',
    },
  ];

  void _update(int index, String status) {
    setState(() {
      restaurants[index]['status'] = status;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Status restoran menjadi $status.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persetujuan Restoran'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(restaurant['address']!),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${restaurant['status']}',
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _update(index, 'Ditolak'),
                          child: const Text('Tolak'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _update(index, 'Disetujui'),
                          child: const Text('Setujui'),
                        ),
                      ),
                    ],
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