import 'package:flutter/material.dart';

import '../models/reservation_model.dart';
import '../utils/colors.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  Color _statusColor() {
    switch (reservation.status) {
      case 'Confirmed':
        return AppColors.success;
      case 'Cancelled':
        return AppColors.danger;
      case 'Completed':
        return Colors.blue;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reservation.restaurantName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reservation.status,
                    style: TextStyle(
                      color: _statusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${reservation.reservationDate.day}/'
              '${reservation.reservationDate.month}/'
              '${reservation.reservationDate.year} • '
              '${reservation.reservationTime}',
            ),
            const SizedBox(height: 5),
            Text('${reservation.guestCount} orang'),
          ],
        ),
      ),
    );
  }
}