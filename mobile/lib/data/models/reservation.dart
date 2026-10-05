enum ReservationStatus { pending, confirmed, completed, cancelled }

class Reservation {
  final String code, restaurantId, restaurantName, restaurantAddress;
  final String? restaurantImage;
  DateTime date;
  String time, tableLabel;
  int guests;
  ReservationStatus status;
  String customerName, phone, note, agoLabel, loyalty, preorderText, tag;
  int preorderTotal;

  Reservation({
    required this.code,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantAddress,
    this.restaurantImage,
    required this.date,
    required this.time,
    required this.tableLabel,
    required this.guests,
    required this.status,
    this.customerName = '',
    this.phone = '',
    this.note = '',
    this.agoLabel = '',
    this.loyalty = '',
    this.preorderText = '',
    this.tag = '',
    this.preorderTotal = 0,
  });

  bool get isActive =>
      status == ReservationStatus.pending ||
      status == ReservationStatus.confirmed;
}