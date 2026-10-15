import 'package:flutter/material.dart';
import '../../core/utils/format.dart';

enum PromoOccasion { ramadan, natal, imlek, valentine, hariRaya, kemerdekaan, spesial }

extension PromoOccasionX on PromoOccasion {
  String get label => switch (this) {
        PromoOccasion.ramadan => 'Ramadan',
        PromoOccasion.natal => 'Natal',
        PromoOccasion.imlek => 'Imlek',
        PromoOccasion.valentine => 'Valentine',
        PromoOccasion.hariRaya => 'Hari Raya',
        PromoOccasion.kemerdekaan => 'Kemerdekaan',
        PromoOccasion.spesial => 'Hari Spesial',
      };

  IconData get icon => switch (this) {
        PromoOccasion.ramadan => Icons.nights_stay_rounded,
        PromoOccasion.natal => Icons.park_rounded,
        PromoOccasion.imlek => Icons.celebration_rounded,
        PromoOccasion.valentine => Icons.favorite_rounded,
        PromoOccasion.hariRaya => Icons.mosque_rounded,
        PromoOccasion.kemerdekaan => Icons.flag_rounded,
        PromoOccasion.spesial => Icons.local_offer_rounded,
      };

  Color get color => switch (this) {
        PromoOccasion.ramadan => const Color(0xFF0B7A55),
        PromoOccasion.natal => const Color(0xFFC62828),
        PromoOccasion.imlek => const Color(0xFFD9480F),
        PromoOccasion.valentine => const Color(0xFFD6336C),
        PromoOccasion.hariRaya => const Color(0xFF2B8A3E),
        PromoOccasion.kemerdekaan => const Color(0xFFE03131),
        PromoOccasion.spesial => const Color(0xFFFF6B35),
      };

  /// Tanggal musiman PERKIRAAN (silakan sesuaikan manual saat membuat promo).
  DateTimeRange get suggestedRange {
    final n = DateTime.now();
    return switch (this) {
      PromoOccasion.ramadan => DateTimeRange(start: DateTime(2027, 2, 8), end: DateTime(2027, 3, 9)),
      PromoOccasion.natal => DateTimeRange(start: DateTime(n.year, 12, 20), end: DateTime(n.year, 12, 26)),
      PromoOccasion.imlek => DateTimeRange(start: DateTime(2027, 2, 6), end: DateTime(2027, 2, 12)),
      PromoOccasion.valentine => DateTimeRange(start: DateTime(2027, 2, 12), end: DateTime(2027, 2, 14)),
      PromoOccasion.hariRaya => DateTimeRange(start: DateTime(2027, 3, 9), end: DateTime(2027, 3, 13)),
      PromoOccasion.kemerdekaan => DateTimeRange(start: DateTime(2027, 8, 14), end: DateTime(2027, 8, 17)),
      PromoOccasion.spesial => DateTimeRange(start: n, end: n.add(const Duration(days: 7))),
    };
  }
}

class Promo {
  final String id;
  String title, description;
  PromoOccasion occasion;
  int percent, quota, claimed;
  DateTime start, end;
  String? restaurantId; // null = berlaku di semua restoran (dibuat Administrator)
  final String createdBy; // 'admin' atau 'administrator'
  bool active;

  Promo({
    required this.id,
    required this.title,
    required this.occasion,
    required this.percent,
    required this.start,
    required this.end,
    required this.quota,
    this.claimed = 0,
    this.restaurantId,
    this.createdBy = 'admin',
    this.active = true,
    this.description = '',
  });

  int get remaining => quota - claimed;

  bool get isRunning {
    final n = DateTime.now();
    final d = DateTime(n.year, n.month, n.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return active && !d.isBefore(s) && !d.isAfter(e) && remaining > 0;
  }

  String get periodText =>
      '${start.day} ${monthShort(start)} ${start.year} – ${end.day} ${monthShort(end)} ${end.year}';
}