import 'package:flutter/foundation.dart';

import '../models/reservation_model.dart';
import '../services/reservation_service.dart';

class ReservationProvider extends ChangeNotifier {
  final ReservationService _service = ReservationService();

  List<Reservation> _reservations = [];
  bool _isLoading = false;
  String? _error;

  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadReservations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reservations = await _service.getReservations();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createReservation({
    required int restaurantId,
    required String restaurantName,
    required String customerName,
    required DateTime date,
    required String time,
    required int guestCount,
    required String notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final reservation = await _service.createReservation(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        customerName: customerName,
        date: date,
        time: time,
        guestCount: guestCount,
        notes: notes,
      );

      _reservations = [
        ..._reservations,
        reservation,
      ];

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStatus(
    int reservationId,
    String status,
  ) async {
    await _service.updateStatus(
      reservationId,
      status,
    );

    final index = _reservations.indexWhere(
      (item) => item.id == reservationId,
    );

    if (index == -1) {
      return;
    }

    final old = _reservations[index];

    _reservations[index] = Reservation(
      id: old.id,
      restaurantId: old.restaurantId,
      restaurantName: old.restaurantName,
      customerName: old.customerName,
      reservationDate: old.reservationDate,
      reservationTime: old.reservationTime,
      guestCount: old.guestCount,
      notes: old.notes,
      status: status,
    );

    notifyListeners();
  }
}