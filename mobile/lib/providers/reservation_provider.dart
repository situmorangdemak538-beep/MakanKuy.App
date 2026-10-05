import 'package:flutter/foundation.dart';
import '../data/dummy_data.dart';
import '../data/models/reservation.dart';
import '../data/models/restaurant.dart';

class ReservationProvider extends ChangeNotifier {
  final List<Reservation> mine = DummyData.myReservations();
  final List<Reservation> incoming = DummyData.incoming();
  int _seq = 0;

  // ---------- Draft form reservasi ----------
  DateTime date = DateTime.now().add(const Duration(days: 1));
  String? time = '19:00';
  int guests = 4;
  String seat = 'Lesehan View Laut & Sunset';
  String note = '';
  bool whatsapp = true;
  final Map<String, int> preorder = {};
  final Map<String, int> preorderUnit = {};

  void setDate(DateTime d) {
    date = d;
    notifyListeners();
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

  int get preorderTotal => preorder.entries
      .fold(0, (sum, e) => sum + e.value * (preorderUnit[e.key] ?? 0));

  String get preorderText =>
      preorder.entries.map((e) => '${e.value}× ${e.key}').join(', ');

  void resetDraft() {
    date = DateTime.now().add(const Duration(days: 1));
    time = '19:00';
    guests = 4;
    seat = 'Lesehan View Laut & Sunset';
    note = '';
    preorder.clear();
    preorderUnit.clear();
  }

  /// DUMMY: nanti POST /api/reservations
  Reservation submit(Restaurant r,
      {required String name, required String phone}) {
    final res = Reservation(
      code: 'MK-TRN-${8830 + _seq++}',
      restaurantId: r.id,
      restaurantName: r.name,
      restaurantAddress: r.address,
      restaurantImage: r.image,
      date: date,
      time: time ?? '19:00',
      tableLabel: seat,
      guests: guests,
      status: ReservationStatus.pending,
      customerName: name,
      phone: phone,
      note: note,
      agoLabel: 'Baru saja',
      preorderText: preorderText,
      preorderTotal: preorderTotal,
    );
    mine.insert(0, res);
    incoming.insert(0, res);
    resetDraft();
    notifyListeners();
    return res;
  }

  // ---------- Customer ----------
  List<Reservation> get active => mine.where((r) => r.isActive).toList();
  List<Reservation> get done => mine.where((r) => !r.isActive).toList();

  void cancel(Reservation r) {
    r.status = ReservationStatus.cancelled;
    notifyListeners();
  }

  // ---------- Admin ----------
  List<Reservation> get pending => incoming
      .where((r) => r.status == ReservationStatus.pending)
      .toList();
  List<Reservation> get approved => incoming
      .where((r) => r.status == ReservationStatus.confirmed)
      .toList();
  List<Reservation> get finished => incoming
      .where((r) =>
          r.status == ReservationStatus.completed ||
          r.status == ReservationStatus.cancelled)
      .toList();

  /// DUMMY: nanti PUT /api/reservations/{id}/status
  void approve(Reservation r) {
    r.status = ReservationStatus.confirmed;
    notifyListeners();
  }

  void reject(Reservation r) {
    r.status = ReservationStatus.cancelled;
    notifyListeners();
  }

  void complete(Reservation r) {
    r.status = ReservationStatus.completed;
    notifyListeners();
  }
}