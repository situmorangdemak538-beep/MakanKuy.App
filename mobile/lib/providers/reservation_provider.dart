import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/utils/format.dart';
import '../data/models/reservation.dart';
import '../data/models/restaurant.dart';
import 'auth_provider.dart';
import '../services/api_config.dart';

class ReservationProvider extends ChangeNotifier {
  // Data reservasi dari Laravel API.
  final List<Reservation> mine = [];
  final List<Reservation> incoming = [];

  String? errorMessage;
  bool loading = false;

  // ---------- Draft form reservasi ----------

  DateTime date = DateTime.now().add(const Duration(days: 1));
  DateTime? endDate;
  bool exclusive = false;
  String? time = '19:00';
  int guests = 4;
  String seat = 'Lesehan View Laut & Sunset';
  String note = '';
  bool whatsapp = true;

  final Map<String, int> preorder = {};
  final Map<String, int> preorderUnit = {};

  Map<String, String> get _headers {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Map<String, String> _authHeaders(AuthProvider auth) {
    return {
      ..._headers,
      'Authorization': 'Bearer ${auth.token}',
    };
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    return Map<String, dynamic>.from(decoded as Map);
  }

  String _errorFromResponse(http.Response response) {
    try {
      final data = _decodeResponse(response);
      final message = data['message']?.toString();

      if (data['errors'] is Map) {
        final errors = Map<String, dynamic>.from(data['errors']);
        if (errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
      }

      return message ?? 'Terjadi kesalahan pada server.';
    } catch (_) {
      return 'Terjadi kesalahan. Periksa koneksi dan server Laravel.';
    }
  }

  String _dateForApi(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');

    return '${value.year}-$month-$day';
  }

  void setDate(DateTime d, [DateTime? e]) {
    date = d;
    endDate = e;
    notifyListeners();
  }

  void setExclusive(bool v) {
    exclusive = v;
    if (!v) endDate = null;
    notifyListeners();
  }

  String get dateText {
    final e = endDate;

    if (e == null) {
      return '${relDay(date)}, ${date.day} ${monthShort(date)} ${date.year}';
    }

    return '${date.day} ${monthShort(date)} – ${e.day} ${monthShort(e)} ${e.year}';
  }

  void setTime(String t) {
    time = t;
    notifyListeners();
  }

  void setGuests(int g) {
    guests = g.clamp(1, 30);
    notifyListeners();
  }

  void setSeat(String s) {
    seat = s;
    notifyListeners();
  }

  void setNote(String s) {
    note = s;
    notifyListeners();
  }

  void appendNote(String s) {
    note = note.isEmpty ? s : '$note, $s';
    notifyListeners();
  }

  void setWhatsapp(bool v) {
    whatsapp = v;
    notifyListeners();
  }

  void addPreorder(String name, int unitPrice, int qty) {
    preorder[name] = (preorder[name] ?? 0) + qty;
    preorderUnit[name] = unitPrice;
    notifyListeners();
  }

  int get preorderTotal => preorder.entries.fold(
        0,
        (sum, e) => sum + e.value * (preorderUnit[e.key] ?? 0),
      );

  String get preorderText =>
      preorder.entries.map((e) => '${e.value}× ${e.key}').join(', ');

  void resetDraft() {
    date = DateTime.now().add(const Duration(days: 1));
    endDate = null;
    exclusive = false;
    time = '19:00';
    guests = 4;
    seat = 'Lesehan View Laut & Sunset';
    note = '';
    whatsapp = true;
    preorder.clear();
    preorderUnit.clear();
    notifyListeners();
  }

  // ---------- Mengambil reservasi dari Laravel ----------

  Future<bool> fetchReservations(AuthProvider auth) async {
    if (auth.token == null || auth.token!.isEmpty) {
      errorMessage = 'Silakan login terlebih dahulu.';
      return false;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.reservations}'),
        headers: _authHeaders(auth),
      );

      if (response.statusCode == 200) {
        final result = _decodeResponse(response);
        final data = result['data'] as List<dynamic>? ?? [];

        final reservations = data
            .map(
              (item) => Reservation.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();

        mine
          ..clear()
          ..addAll(reservations);

        incoming
          ..clear()
          ..addAll(reservations);

        return true;
      }

      errorMessage = _errorFromResponse(response);
      return false;
    } catch (e) {
      errorMessage = 'Tidak dapat terhubung ke server Laravel.';
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ---------- Membuat reservasi baru ----------

  Future<Reservation?> submit(
    AuthProvider auth,
    Restaurant restaurant, {
    required String name,
    required String phone,
    int discountPercent = 0,
  }) async {
    if (auth.token == null || auth.token!.isEmpty) {
      errorMessage = 'Silakan login terlebih dahulu.';
      return null;
    }

    final restaurantId = int.tryParse(restaurant.id);

    if (restaurantId == null) {
      errorMessage = 'ID restoran tidak valid.';
      return null;
    }

    errorMessage = null;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.reservations}'),
        headers: _authHeaders(auth),
        body: jsonEncode({
          'restaurant_id': restaurantId,
          'tanggal': _dateForApi(date),
          'end_date': endDate == null ? null : _dateForApi(endDate!),
          'jam': (time ?? '19:00').substring(0, 5),
          'jumlah_orang': guests,
          'exclusive': exclusive,
          'table_label': seat,
          'customer_name': name,
          'phone': phone,
          'note': note,
          'whatsapp': whatsapp,
          'preorder_text': preorderText,
          'preorder_total': preorderTotal,
          'discount_percent': discountPercent,
        }),
      );

      if (response.statusCode == 201) {
        final result = _decodeResponse(response);
        final reservation = Reservation.fromJson(
          Map<String, dynamic>.from(result['data'] as Map),
        );

        mine.insert(0, reservation);
        incoming.insert(0, reservation);

        resetDraft();
        notifyListeners();

        return reservation;
      }

      errorMessage = _errorFromResponse(response);
      return null;
    } catch (e) {
      errorMessage = 'Reservasi gagal dikirim. Periksa koneksi server.';
      return null;
    }
  }

  // ---------- Customer: membatalkan reservasi ----------

  Future<bool> cancel(AuthProvider auth, Reservation reservation) async {
    if (auth.token == null || auth.token!.isEmpty) {
      errorMessage = 'Silakan login terlebih dahulu.';
      return false;
    }

    if (reservation.id == null) {
      errorMessage = 'ID reservasi tidak ditemukan.';
      return false;
    }

    try {
      final response = await http.delete(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.reservations}/${reservation.id}',
        ),
        headers: _authHeaders(auth),
      );

      if (response.statusCode == 200) {
        reservation.status = ReservationStatus.cancelled;
        errorMessage = null;
        notifyListeners();
        return true;
      }

      errorMessage = _errorFromResponse(response);
      return false;
    } catch (e) {
      errorMessage = 'Pembatalan gagal. Periksa koneksi server.';
      return false;
    }
  }

  // ---------- Admin restoran: memperbarui status ----------

  Future<bool> updateStatus(
    AuthProvider auth,
    Reservation reservation,
    String status,
  ) async {
    if (auth.token == null || auth.token!.isEmpty) {
      errorMessage = 'Silakan login terlebih dahulu.';
      return false;
    }

    if (reservation.id == null) {
      errorMessage = 'ID reservasi tidak ditemukan.';
      return false;
    }

    try {
      final response = await http.put(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.reservationStatus(reservation.id.toString())}',
        ),
        headers: _authHeaders(auth),
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final result = _decodeResponse(response);
        final updated = Reservation.fromJson(
          Map<String, dynamic>.from(result['data'] as Map),
        );

        reservation.status = updated.status;
        errorMessage = null;
        notifyListeners();
        return true;
      }

      errorMessage = _errorFromResponse(response);
      return false;
    } catch (e) {
      errorMessage = 'Status reservasi gagal diperbarui.';
      return false;
    }
  }

  // ---------- Daftar reservasi ----------

  List<Reservation> get active =>
      mine.where((r) => r.isActive).toList();

  List<Reservation> get done =>
      mine.where((r) => !r.isActive).toList();

  // ---------- Daftar reservasi Admin Restoran ----------

  List<Reservation> get pending =>
      incoming.where((r) => r.status == ReservationStatus.pending).toList();

  List<Reservation> get approved =>
      incoming.where((r) => r.status == ReservationStatus.confirmed).toList();

  List<Reservation> get finished => incoming
      .where(
        (r) =>
            r.status == ReservationStatus.completed ||
            r.status == ReservationStatus.cancelled,
      )
      .toList();

  // ---------- Monitoring Administrator ----------

  List<Reservation> get everything {
    final seen = <String>{};
    final result = <Reservation>[];

    for (final reservation in [...incoming, ...mine]) {
      final key = reservation.id?.toString() ?? reservation.code;

      if (seen.add(key)) {
        result.add(reservation);
      }
    }

    return result;
  }
}