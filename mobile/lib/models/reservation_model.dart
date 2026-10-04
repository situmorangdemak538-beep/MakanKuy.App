class ReservationModel {
  final int id;
  final String restaurantName;
  final String customerName;
  final String date;
  final String time;
  final int guests;
  final String status;
  final String note;

  const ReservationModel({
    required this.id,
    required this.restaurantName,
    required this.customerName,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    required this.note,
  });
}