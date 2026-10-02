import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/reservation_provider.dart';
import '../../widgets/reservation_card.dart';

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({super.key});

  @override
  State<ReservationHistoryScreen> createState() =>
      _ReservationHistoryScreenState();
}

class _ReservationHistoryScreenState
    extends State<ReservationHistoryScreen> {
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
        title: const Text('Riwayat Reservasi'),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.reservations.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada reservasi.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.reservations.length,
                  itemBuilder: (context, index) {
                    return ReservationCard(
                      reservation:
                          provider.reservations[index],
                    );
                  },
                ),
    );
  }
}