import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:makankuy/models/restaurant_model.dart';
import 'package:makankuy/providers/auth_provider.dart';
import 'package:makankuy/providers/reservation_provider.dart';
import 'package:makankuy/routes/app_routes.dart';
import 'package:makankuy/utils/colors.dart';

class ReservationFormScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const ReservationFormScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  DateTime? date;
  TimeOfDay? time;
  int guests = 2;
  final note = TextEditingController();

  Future<void> submit() async {
    if (date == null || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal dan jam reservasi.'),
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();

    await context.read<ReservationProvider>().createReservation(
          restaurantName: widget.restaurant.name,
          customerName: auth.user?.name ?? 'Customer',
          date: '${date!.day}/${date!.month}/${date!.year}',
          time: time!.format(context),
          guests: guests,
          note: note.text.trim(),
        );

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reservasi Berhasil'),
        content: const Text(
          'Reservasi telah dicatat dengan status Pending. Riwayat reservasi dapat dilihat pada menu Reservasi.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.history,
                (_) => false,
              );
            },
            child: const Text('Lihat Riwayat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Reservasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Text(
            widget.restaurant.name,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            widget.restaurant.address,
            style: const TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih Tanggal',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          _selector(
            icon: Icons.calendar_month,
            text: date == null
                ? 'Pilih tanggal'
                : '${date!.day}/${date!.month}/${date!.year}',
            onTap: () async {
              final result = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                initialDate: DateTime.now(),
              );
              if (result != null) {
                setState(() => date = result);
              }
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Pilih Jam Kedatangan',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          _selector(
            icon: Icons.access_time,
            text: time == null ? 'Pilih jam' : time!.format(context),
            onTap: () async {
              final result = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 19, minute: 0),
              );
              if (result != null) {
                setState(() => time = result);
              }
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Jumlah Orang',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_outline, color: AppColors.primary),
                const SizedBox(width: 10),
                const Expanded(child: Text('Jumlah tamu')),
                IconButton(
                  onPressed: guests > 1
                      ? () => setState(() => guests--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$guests',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => guests++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Catatan',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: note,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Contoh: meja dekat jendela...',
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Konfirmasi Reservasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selector({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(text),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}