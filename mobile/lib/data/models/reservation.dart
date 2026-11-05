import '../../core/utils/format.dart';

enum ReservationStatus { pending, confirmed, completed, cancelled }

class Reservation {
  // ID database Laravel.
  final int? id;

  final String code, restaurantId, restaurantName, restaurantAddress;
  final String? restaurantImage;

  DateTime date;
  DateTime? endDate;
  bool exclusive;
  String time, tableLabel;
  int guests;
  ReservationStatus status;

  String customerName, phone, note, agoLabel, loyalty, preorderText, tag;
  int preorderTotal, discountPercent;

  Reservation({
    this.id,
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
      ? '${date.day} ${monthShort(date)} ${date.year}'
      : '${date.day} ${monthShort(date)} – ${endDate!.day} ${monthShort(endDate!)} ${endDate!.year}';

  // Mengubah JSON Laravel menjadi objek Reservation.
  factory Reservation.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'] is Map
        ? Map<String, dynamic>.from(json['restaurant'])
        : <String, dynamic>{};

    String text(dynamic value, [String fallback = '']) {
      return value?.toString() ?? fallback;
    }

    int number(dynamic value, [int fallback = 0]) {
      if (value is num) return value.toInt();
      return int.tryParse(text(value)) ?? fallback;
    }

    final statusText = text(json['status'], 'pending');

    final restaurantName = text(
      restaurant['nama'],
      'Restoran',
    );

    final restaurantImage = restaurantName.toLowerCase().contains('fufu')
        ? 'assets/images/resto_fufu.jpg'
        : restaurantName.toLowerCase().contains('gamalama')
            ? 'assets/images/resto_gamalama.jpg'
            : 'assets/images/resto_default.jpg';

    return Reservation(
      id: number(json['id']),
      code: text(json['code'], 'MK-TRN-${json['id']}'),
      restaurantId: text(json['restaurant_id']),
      restaurantName: restaurantName,
      restaurantAddress: text(
        restaurant['alamat'],
        'Alamat belum tersedia',
      ),
      restaurantImage: restaurantImage,
      date: DateTime.parse(text(json['tanggal'])),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(text(json['end_date'])),
      exclusive: json['exclusive'] == true || number(json['exclusive']) == 1,
      time: text(json['jam'], '19:00').substring(0, 5),
      tableLabel: text(json['table_label'], 'Tempat belum dipilih'),
      guests: number(json['jumlah_orang'], 1),
      status: ReservationStatus.values.firstWhere(
        (value) => value.name == statusText,
        orElse: () => ReservationStatus.pending,
      ),
      customerName: text(json['customer_name']),
      phone: text(json['phone']),
      note: text(json['note']),
      preorderText: text(json['preorder_text']),
      preorderTotal: number(json['preorder_total']),
      discountPercent: number(json['discount_percent']),
    );
  }
}
