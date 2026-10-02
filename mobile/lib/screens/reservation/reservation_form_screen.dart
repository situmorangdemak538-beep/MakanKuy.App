import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/reservation_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/validators.dart';

class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key});

  @override
  State<ReservationFormScreen> createState() =>
      _ReservationFormScreenState();
}

class _ReservationFormScreenState
    extends State<ReservationFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate =
      DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 19, minute: 0);
  int guests = 2;

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ),
      initialDate: selectedDate,
    );

    if (result != null) {
      setState(() => selectedDate = result);
    }
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (result != null) {
      setState(() => selectedTime = result);
    }
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;

    final provider = context.read<ReservationProvider>();

    final success = await provider.createReservation(
      restaurantId: 1,
      restaurantName: 'MakanKuy Resto',
      customerName: nameController.text.trim(),
      date: selectedDate,
      time: selectedTime.format(context),
      guestCount: guests,
      notes: noteController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservasi berhasil dibuat.'),
        ),
      );
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.reservationHistory,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Reservasi gagal.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<ReservationProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Reservasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: Validators.validateName,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemesan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),
                title: const Text('Tanggal'),
                subtitle: Text(
                  '${selectedDate.day}/'
                  '${selectedDate.month}/'
                  '${selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),
                title: const Text('Waktu'),
                subtitle: Text(
                  selectedTime.format(context),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: guests,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Tamu',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1} orang'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => guests = value);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Buat Reservasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}