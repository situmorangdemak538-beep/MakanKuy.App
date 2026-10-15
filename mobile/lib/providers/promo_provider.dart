import 'package:flutter/foundation.dart';
import '../data/models/promo.dart';

class PromoProvider extends ChangeNotifier {
  final List<Promo> promos = [];
  final Set<String> claimedIds = {};
  String? appliedId; // voucher yang dipakai di form reservasi

  PromoProvider() {
    // DUMMY (nanti dari GET /api/promos)
    final n = DateTime.now();
    final t = DateTime(n.year, n.month, n.day);
    promos.addAll([
      Promo(
          id: 'p1',
          title: 'Diskon Meja 25% Hari Ini!',
          occasion: PromoOccasion.spesial,
          percent: 25,
          start: t.subtract(const Duration(days: 1)),
          end: t.add(const Duration(days: 6)),
          quota: 30,
          claimed: 22,
          createdBy: 'administrator',
          description:
              'Nikmati kuliner legendaris pesisir Ternate bersama kerabat & keluarga tercinta.'),
      Promo(
          id: 'p2',
          title: 'Weekend Gohu Hemat 15%',
          occasion: PromoOccasion.spesial,
          percent: 15,
          start: t,
          end: t.add(const Duration(days: 14)),
          quota: 50,
          claimed: 8,
          restaurantId: 'r1',
          description: 'Khusus RM Gohu Ikan Gamalama setiap akhir pekan.'),
      Promo(
          id: 'p3',
          title: 'Promo Natal Bersama',
          occasion: PromoOccasion.natal,
          percent: 20,
          start: DateTime(n.year, 12, 20),
          end: DateTime(n.year, 12, 26),
          quota: 100,
          createdBy: 'administrator',
          description: 'Reservasi meja keluarga selama pekan Natal.'),
      Promo(
          id: 'p4',
          title: 'Buka Puasa Hemat Ramadan',
          occasion: PromoOccasion.ramadan,
          percent: 15,
          start: DateTime(2027, 2, 8),
          end: DateTime(2027, 3, 9),
          quota: 200,
          restaurantId: 'r1',
          description: 'Paket buka puasa untuk rombongan.'),
      Promo(
          id: 'p5',
          title: 'Valentine Dinner Berdua',
          occasion: PromoOccasion.valentine,
          percent: 18,
          start: DateTime(2027, 2, 12),
          end: DateTime(2027, 2, 14),
          quota: 60,
          createdBy: 'administrator',
          description: 'Meja romantis menghadap laut saat senja.'),
    ]);
  }

  List<Promo> get running => promos.where((p) => p.isRunning).toList();

  bool isClaimed(String id) => claimedIds.contains(id);

  /// DUMMY. Backend: POST /api/promos/{id}/claim
  bool claim(Promo p) {
    if (claimedIds.contains(p.id) || !p.isRunning) return false;
    p.claimed++;
    claimedIds.add(p.id);
    appliedId = p.id;
    notifyListeners();
    return true;
  }

  Promo? get applied {
    for (final p in promos) {
      if (p.id == appliedId) return p;
    }
    return null;
  }

  /// Admin restoran: hanya promo warungnya. Administrator: semua promo.
  List<Promo> manageable({required bool isAdministrator, String? restaurantId}) =>
      isAdministrator
          ? List.of(promos)
          : promos.where((p) => p.restaurantId == restaurantId).toList();

  void add(Promo p) {
    promos.insert(0, p);
    notifyListeners();
  }

  void touch() => notifyListeners(); // dipanggil setelah mengubah field promo

  void toggle(Promo p) {
    p.active = !p.active;
    notifyListeners();
  }

  void remove(Promo p) {
    promos.remove(p);
    notifyListeners();
  }
}