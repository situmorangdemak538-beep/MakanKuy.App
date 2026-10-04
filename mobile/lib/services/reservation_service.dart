import 'package:makankuy/models/reservation_model.dart';

class ReservationService {
  final List<ReservationModel> _data = [];

  List<ReservationModel> get history => List.unmodifiable(_data);

  Future<void> add({
    required String restaurantName,
    required String customerName,
    required String date,
    required String time,
    required int guests,
    required String note,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    _data.insert(
      0,
      ReservationModel(
        id: _data.length + 1,
        restaurantName: restaurantName,
        customerName: customerName,
        date: date,
        time: time,
        guests: guests,
        status: 'Pending',
        note: note,
      ),
    );
  }
}