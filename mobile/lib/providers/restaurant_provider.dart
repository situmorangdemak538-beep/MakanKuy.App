import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../data/models/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {
  /// Hanya warung berstatus APPROVED (tampil ke customer).
  final List<Restaurant> all = List.of(DummyData.restaurants);

  /// Warung baru yang menunggu persetujuan Administrator (DUMMY).
  final List<Restaurant> pending = [
    Restaurant(
      id: 'rp1',
      name: 'Warung Ikan Bakar Pak Hasan',
      category: 'Seafood Bakar',
      area: 'Ternate Selatan',
      address: 'Jl. Pelabuhan Bastiong No. 7',
      image: 'assets/images/resto_default.jpg',
      distanceKm: 3.2,
      rating: 0,
      reviews: 0,
      priceFrom: 25000,
      tablesFree: 8,
      specialty: 'Ikan bakar rica-rica',
      totalTables: 8,
      seatsPerTable: 4,
      ownerName: 'Pak Hasan Tidore',
      openTime: '11:00',
      closeTime: '21:00',
      hours: '11:00 - 21:00 WIT',
      status: RestaurantStatus.pending,
    ),
    Restaurant(
      id: 'rp2',
      name: 'Kedai Kopi Salero',
      category: 'Cafe & Kopi',
      area: 'Ternate Tengah',
      address: 'Jl. Salero Indah No. 3',
      image: 'assets/images/resto_default.jpg',
      distanceKm: 1.9,
      rating: 0,
      reviews: 0,
      priceFrom: 15000,
      tablesFree: 12,
      specialty: 'Kopi rempah dan pisang goreng',
      totalTables: 12,
      seatsPerTable: 2,
      ownerName: 'Ibu Ratna Salero',
      openTime: '08:00',
      closeTime: '23:00',
      hours: '08:00 - 23:00 WIT',
      status: RestaurantStatus.pending,
    ),
  ];

  String query = '';
  String? area = 'Ternate Tengah';
  bool rating45 = false;
  bool tableOnly = false;
  bool under50 = false;
  String sort = 'Terdekat';

  final Set<String> saved = {'r1', 'r2'};

  List<Restaurant> get popular => all.where((r) => r.isPopular).toList();
  List<Restaurant> get nearby => all.where((r) => r.isNearby).toList();

  List<Restaurant> get results {
    final q = query.trim().toLowerCase();
    final list = all.where((r) {
      if (q.isNotEmpty) {
        final hay = '${r.name} ${r.category} ${r.specialty} ${r.tags.join(' ')}'
            .toLowerCase();
        if (!hay.contains(q)) return false;
      }
      if (area != null && r.area != area) return false;
      if (rating45 && r.rating < 4.5) return false;
      if (tableOnly && r.tablesFree <= 0) return false;
      if (under50 && r.priceFrom >= 50000) return false;
      return true;
    }).toList();
    if (sort == 'Rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return list;
  }

  // ---------- Pendaftaran warung ----------
  /// DUMMY. Backend: POST /api/restaurants
  /// Admin restoran -> status pending. Administrator -> langsung approved.
  void addRestaurant(Restaurant r) {
    if (r.status == RestaurantStatus.approved) {
      all.insert(0, r);
    } else {
      pending.insert(0, r);
    }
    notifyListeners();
  }
  /// DUMMY. Backend: PUT /api/restaurants/{id}/approve
  void approve(Restaurant r) {
    r.status = RestaurantStatus.approved;
    pending.remove(r);
    all.insert(0, r);
    notifyListeners();
  }

  /// DUMMY. Backend: PUT /api/restaurants/{id}/reject
  void reject(Restaurant r) {
    r.status = RestaurantStatus.rejected;
    pending.remove(r);
    notifyListeners();
  }

  /// Warung milik pengelola (demo: r1 selalu ikut + warung yang ia daftarkan).
  List<Restaurant> ownedBy(String owner) => [
        ...all.where((r) => r.ownerName == owner || r.id == 'r1'),
        ...pending.where((r) => r.ownerName == owner),
      ];

  // ---------- Pencarian ----------
  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  void setArea(String? v) {
    area = v;
    notifyListeners();
  }

  void toggleRating() {
    rating45 = !rating45;
    notifyListeners();
  }

  void toggleTable() {
    tableOnly = !tableOnly;
    notifyListeners();
  }

  void toggleUnder50() {
    under50 = !under50;
    notifyListeners();
  }

  void setSort(String v) {
    sort = v;
    notifyListeners();
  }

  bool isSaved(String id) => saved.contains(id);

  void toggleSaved(String id) {
    saved.contains(id) ? saved.remove(id) : saved.add(id);
    notifyListeners();
  }
}
