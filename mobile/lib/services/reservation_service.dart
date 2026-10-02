import '../models/reservation_model.dart';

class ReservationService {
  final List<Reservation> _reservations = [];

  Future<List<Reservation>> getReservations() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 200),
    );
    return List<Reservation>.from(_reservations);
  }

  Future<Reservation> createReservation({
    required int restaurantId,
    required String restaurantName,
    required String customerName,
    required DateTime date,
    required String time,
    required int guestCount,
    required String notes,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );

    final reservation = Reservation(
      id: _reservations.length + 1,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      customerName: customerName,
      reservationDate: date,
      reservationTime: time,
      guestCount: guestCount,
      notes: notes,
      status: 'Pending',
    );

    _reservations.add(reservation);
    return reservation;
  }

  Future<void> updateStatus(
    int reservationId,
    String status,
  ) async {
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
  }
}