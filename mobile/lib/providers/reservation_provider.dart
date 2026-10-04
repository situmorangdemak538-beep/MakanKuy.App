import 'package:flutter/foundation.dart';
import 'package:makankuy/models/reservation_model.dart';
import 'package:makankuy/services/reservation_service.dart';

class ReservationProvider extends ChangeNotifier {
  final ReservationService _service = ReservationService();

  List<ReservationModel> get reservations => _service.history;

  Future<void> createReservation({
    required String restaurantName,
    required String customerName,
    required String date,
    required String time,
    required int guests,
    required String note,
  }) async {
    await _service.add(
      restaurantName: restaurantName,
      customerName: customerName,
      date: date,
      time: time,
      guests: guests,
      note: note,
    );
    notifyListeners();
  }
}