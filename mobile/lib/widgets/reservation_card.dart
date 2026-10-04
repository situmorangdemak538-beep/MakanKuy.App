import 'package:flutter/material.dart';
import 'package:makankuy/models/reservation_model.dart';
import 'package:makankuy/utils/colors.dart';

class ReservationCard extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = reservation.status == 'Confirmed'
        ? AppColors.success
        : reservation.status == 'Cancelled'
            ? AppColors.danger
            : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reservation.restaurantName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  reservation.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('${reservation.date} • ${reservation.time}'),
          const SizedBox(height: 5),
          Text('${reservation.guests} orang'),
          if (reservation.note.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              reservation.note,
              style: const TextStyle(color: AppColors.grey),
            ),
          ],
        ],
      ),
    );
  }
}