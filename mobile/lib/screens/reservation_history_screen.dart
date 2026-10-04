import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:makankuy/providers/reservation_provider.dart';
import 'package:makankuy/utils/colors.dart';
import 'package:makankuy/widgets/reservation_card.dart';

class ReservationHistoryScreen extends StatelessWidget {
  const ReservationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations = context.watch<ReservationProvider>().reservations;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          const Text(
            'Riwayat Reservasi',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 7),
          const Text(
            'Pantau reservasi meja yang pernah kamu buat.',
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 18),
          if (reservations.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 58,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada reservasi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Reservasi restoran favoritmu akan muncul di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            )
          else
            ...reservations.map(
              (reservation) => ReservationCard(reservation: reservation),
            ),
        ],
      ),
    );
  }
}