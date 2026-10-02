import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/reservation_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/reservation_card.dart';

class AdminReservationScreen extends StatefulWidget {
  const AdminReservationScreen({super.key});

  @override
  State<AdminReservationScreen> createState() =>
      _AdminReservationScreenState();
}

class _AdminReservationScreenState
    extends State<AdminReservationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ReservationProvider>()
          .loadReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReservationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Reservasi'),
      ),
      body: provider.reservations.isEmpty
          ? const Center(
              child: Text(
                'Belum ada reservasi masuk.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.reservations.length,
              itemBuilder: (context, index) {
                final item = provider.reservations[index];

                return Column(
                  children: [
                    ReservationCard(reservation: item),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              provider.updateStatus(
                                item.id,
                                'Cancelled',
                              );
                            },
                            child: const Text(
                              'Tolak',
                              style: TextStyle(
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              provider.updateStatus(
                                item.id,
                                'Confirmed',
                              );
                            },
                            child: const Text('Konfirmasi'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
    );
  }
}