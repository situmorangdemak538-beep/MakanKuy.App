import 'package:flutter/foundation.dart';

enum DayStatus { free, full, booked, past }

/// Satu rentang tanggal terkunci pada sebuah restoran.
class DateLock {
  final String code; // kode reservasi / 'manual-xxx' / 'seed'
  final DateTime start, end;
  final bool booked; // true = dipesan klien lain, false = penuh (dikunci pengelola)
  final String reason;
  DateLock(this.code, this.start, this.end,
      {this.booked = false, this.reason = ''});
}

class AvailabilityProvider extends ChangeNotifier {
  final Map<String, List<DateLock>> _locks = {};

  static DateTime day(DateTime x) => DateTime(x.year, x.month, x.day);

  AvailabilityProvider() {
    // DUMMY: data awal supaya kalender langsung terlihat ada tanggal terkunci.
    final t = day(DateTime.now());
    DateTime p(int n) => t.add(Duration(days: n));
    _locks['r1'] = [
      DateLock('seed1', p(2), p(4), reason: 'Penuh (acara pribadi)'),
      DateLock('seed2', p(9), p(10), booked: true, reason: 'Dipesan klien lain'),
    ];
    _locks['r2'] = [DateLock('seed3', p(5), p(7), reason: 'Penuh')];
    _locks['r5'] = [
      DateLock('seed4', p(1), p(3), booked: true, reason: 'Dipesan klien lain')
    ];
  }

  List<DateLock> locksOf(String rid) =>
      List.unmodifiable(_locks[rid] ?? const <DateLock>[]);

  /// DUMMY. Backend: GET /api/restaurants/{id}/availability?from=&to=
  DayStatus statusOf(String rid, DateTime date) {
    final d = day(date);
    if (d.isBefore(day(DateTime.now()))) return DayStatus.past;
    for (final l in _locks[rid] ?? const <DateLock>[]) {
      if (!d.isBefore(l.start) && !d.isAfter(l.end)) {
        return l.booked ? DayStatus.booked : DayStatus.full;
      }
    }
    return DayStatus.free;
  }

  bool rangeFree(String rid, DateTime s, DateTime e) {
    var d = day(s);
    final end = day(e);
    while (!d.isAfter(end)) {
      if (statusOf(rid, d) != DayStatus.free) return false;
      d = d.add(const Duration(days: 1));
    }
    return true;
  }

  /// Jumlah hari tersedia dalam [days] hari ke depan.
  int freeCount(String rid, int days) {
    var c = 0;
    final t = day(DateTime.now());
    for (var i = 0; i < days; i++) {
      if (statusOf(rid, t.add(Duration(days: i))) == DayStatus.free) c++;
    }
    return c;
  }

  DateTime? firstFree(String rid) {
    final t = day(DateTime.now());
    for (var i = 0; i < 90; i++) {
      final d = t.add(Duration(days: i));
      if (statusOf(rid, d) == DayStatus.free) return d;
    }
    return null;
  }

  /// Kunci tanggal. Backend: POST /api/restaurants/{id}/locks
  void lock(String rid, DateTime s, DateTime e, String code,
      {bool booked = true, String reason = 'Dipesan klien lain'}) {
    (_locks[rid] ??= <DateLock>[])
        .add(DateLock(code, day(s), day(e), booked: booked, reason: reason));
    notifyListeners();
  }

  /// Buka kunci. Backend: DELETE /api/locks/{id}
  void unlock(String code) {
    for (final list in _locks.values) {
      list.removeWhere((l) => l.code == code);
    }
    notifyListeners();
  }
}