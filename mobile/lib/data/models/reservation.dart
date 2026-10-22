import '../../core/utils/format.dart';

enum ReservationStatus { pending, confirmed, completed, cancelled }

class Reservation {
  final String code, restaurantId, restaurantName, restaurantAddress;
  final String? restaurantImage;
  DateTime date;
  DateTime? endDate; // tanggal akhir bila booking periode
  bool exclusive; // true = booking seluruh tempat (mengunci tanggal)
  String time, tableLabel;
  int guests;
  ReservationStatus status;
  String customerName, phone, note, agoLabel, loyalty, preorderText, tag;
  int preorderTotal, discountPercent;

  Reservation({
    required this.code,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantAddress,
    this.restaurantImage,
    required this.date,
    this.endDate,
    this.exclusive = false,
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
    this.discountPercent = 0,
  });

  bool get isActive =>
      status == ReservationStatus.pending ||
      status == ReservationStatus.confirmed;

  String get dateText => endDate == null
      ? dateLabel(date)
      : '${date.day} ${monthShort(date)} – ${endDate!.day} ${monthShort(endDate!)} ${endDate!.year}';
}