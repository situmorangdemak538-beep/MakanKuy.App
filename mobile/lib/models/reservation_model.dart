class Reservation {
  final int id;
  final int restaurantId;
  final String restaurantName;
  final String customerName;
  final DateTime reservationDate;
  final String reservationTime;
  final int guestCount;
  final String notes;
  final String status;

  const Reservation({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.customerName,
    required this.reservationDate,
    required this.reservationTime,
    required this.guestCount,
    required this.notes,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: int.tryParse('${json['id']}') ?? 0,
      restaurantId: int.tryParse('${json['restaurant_id']}') ?? 0,
      restaurantName: '${json['restaurant_name'] ?? ''}',
      customerName: '${json['customer_name'] ?? ''}',
      reservationDate:
          DateTime.tryParse('${json['reservation_date']}') ??
              DateTime.now(),
      reservationTime: '${json['reservation_time'] ?? ''}',
      guestCount: int.tryParse('${json['guest_count']}') ?? 0,
      notes: '${json['notes'] ?? ''}',
      status: '${json['status'] ?? 'Pending'}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'customer_name': customerName,
      'reservation_date':
          reservationDate.toIso8601String(),
      'reservation_time': reservationTime,
      'guest_count': guestCount,
      'notes': notes,
      'status': status,
    };
  }
}