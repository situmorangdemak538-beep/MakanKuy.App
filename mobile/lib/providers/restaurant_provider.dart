
import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../data/models/restaurant.dart';
import '../services/restaurant_api_service.dart';
import 'auth_provider.dart';

class RestaurantProvider extends ChangeNotifier {
  /// Data restoran utama untuk tampilan aplikasi.
  final List<Restaurant> all = List.of(DummyData.restaurants);

  /// Data restoran dari Laravel.
  List<Restaurant> apiRestaurants = [];

  /// Daftar pengajuan restoran dari database.
  final List<Restaurant> pending = [];

  final RestaurantApiService _restaurantApiService =
      RestaurantApiService();

  bool isLoadingRestaurants = false;
  bool isLoadingPending = false;
  String? restaurantApiError;
  int? apiRestaurantCount;

  /// Mengambil daftar restoran dari Laravel.
  Future<void> testRestaurantApi() async {
    isLoadingRestaurants = true;
    restaurantApiError = null;
    notifyListeners();

    try {
      final data = await _restaurantApiService.fetchRestaurants();

      apiRestaurants = data.map((item) {
        return Restaurant.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();

      apiRestaurantCount = apiRestaurants.length;

      debugPrint('API restoran berhasil diakses.');
      debugPrint('Jumlah restoran: ${apiRestaurants.length}');
    } catch (e, stackTrace) {
      restaurantApiError = e.toString();
      debugPrint('Gagal mengakses API restoran: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoadingRestaurants = false;
      notifyListeners();
    }
  }

  /// Mengambil daftar pengajuan dari dashboard Administrator.
  Future<void> fetchPendingRestaurants(AuthProvider auth) async {
    final token = auth.token;

    if (token == null || token.isEmpty) {
      restaurantApiError = 'Token login tidak ditemukan.';
      notifyListeners();
      return;
    }

    isLoadingPending = true;
    restaurantApiError = null;
    notifyListeners();

    try {
      final data =
          await _restaurantApiService.fetchAdministratorDashboard(
        token: token,
      );

      final daftar = data['daftar_restoran_pending'];

      if (daftar is! List) {
        throw Exception('Daftar pengajuan restoran tidak ditemukan.');
      }

      pending
        ..clear()
        ..addAll(
          daftar.map((item) {
            final json = Map<String, dynamic>.from(item as Map);
            final restaurant = Restaurant.fromJson(json);

            final user = json['user'];

if (user is Map) {
  final ownerName = user['name']?.toString() ?? '';

  return Restaurant(
    id: restaurant.id,
    name: restaurant.name,
    category: restaurant.category,
    area: restaurant.area,
    address: restaurant.address,
    image: restaurant.image,
    distanceKm: restaurant.distanceKm,
    rating: restaurant.rating,
    reviews: restaurant.reviews,
    priceFrom: restaurant.priceFrom,
    priceTo: restaurant.priceTo,
    priceNote: restaurant.priceNote,
    tablesFree: restaurant.tablesFree,
    specialtyLabel: restaurant.specialtyLabel,
    specialty: restaurant.specialty,
    badge: restaurant.badge,
    highlight: restaurant.highlight,
    tags: restaurant.tags,
    isPopular: restaurant.isPopular,
    isNearby: restaurant.isNearby,
    hours: restaurant.hours,
    whatsapp: restaurant.whatsapp,
    driveMinutes: restaurant.driveMinutes,
    totalTables: restaurant.totalTables,
    seatsPerTable: restaurant.seatsPerTable,
    openTime: restaurant.openTime,
    closeTime: restaurant.closeTime,
    openDays: restaurant.openDays,
    facilities: restaurant.facilities,
    ownerName: ownerName,
    description: restaurant.description,
    status: restaurant.status,
  );
}

return restaurant;
          }),
        );

      debugPrint('Daftar pengajuan restoran berhasil diambil.');
      debugPrint('Jumlah pengajuan: ${pending.length}');
    } catch (e, stackTrace) {
      restaurantApiError = e.toString();
      debugPrint('Gagal mengambil pengajuan restoran: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoadingPending = false;
      notifyListeners();
    }
  }

  /// Mendaftarkan restoran melalui Laravel.
  Future<Restaurant> registerRestaurant(
    AuthProvider auth,
    Restaurant restaurant,
  ) async {
    final token = auth.token;

    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan. Silakan login kembali.');
    }

    final data = await _restaurantApiService.createRestaurant(
      token: token,
      data: {
        'nama': restaurant.name,
        'alamat': restaurant.address,
        'kategori': restaurant.category,
        'deskripsi': restaurant.description,
        'jam_buka': restaurant.openTime,
        'jam_tutup': restaurant.closeTime,
        'harga_min': restaurant.priceFrom,
        'harga_max': restaurant.priceTo,
        'harga_rata_rata':
            ((restaurant.priceFrom + restaurant.priceTo) / 2).round(),
      },
    );

    final savedRestaurant = Restaurant.fromJson(data);

    // Ambil kembali daftar pengajuan terbaru dari database.
    await fetchPendingRestaurants(auth);

    return savedRestaurant;
  }

  /// Menyetujui restoran melalui Laravel.
  Future<void> approve(
    AuthProvider auth,
    Restaurant restaurant,
  ) async {
    final token = auth.token;

    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan.');
    }

    await _restaurantApiService.approveRestaurant(
      token: token,
      id: restaurant.id,
    );

    // Perbarui daftar setelah Laravel berhasil mengubah status.
    restaurant.status = RestaurantStatus.approved;
    pending.removeWhere((r) => r.id == restaurant.id);

    if (!all.any((r) => r.id == restaurant.id)) {
      all.insert(0, restaurant);
    }

    notifyListeners();

    await fetchPendingRestaurants(auth);
  }

  /// Menolak restoran melalui Laravel.
  Future<void> reject(
    AuthProvider auth,
    Restaurant restaurant,
  ) async {
    final token = auth.token;

    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan.');
    }

    await _restaurantApiService.rejectRestaurant(
      token: token,
      id: restaurant.id,
    );

    restaurant.status = RestaurantStatus.rejected;
    pending.removeWhere((r) => r.id == restaurant.id);

    notifyListeners();

    await fetchPendingRestaurants(auth);
  }

  String query = '';
  String? area = 'Ternate Tengah';
  bool rating45 = false;
  bool tableOnly = false;
  bool under50 = false;
  String sort = 'Terdekat';

  final Set<String> saved = {'r1', 'r2'};

  List<Restaurant> get popular =>
      all.where((r) => r.isPopular).toList();

  List<Restaurant> get nearby =>
      all.where((r) => r.isNearby).toList();

  List<Restaurant> get results {
    final q = query.trim().toLowerCase();

    final list = all.where((r) {
      if (q.isNotEmpty) {
        final hay =
            '${r.name} ${r.category} ${r.specialty} ${r.tags.join(' ')}'
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

  // Fungsi dummy lama dipertahankan untuk kompatibilitas.
  void addRestaurant(Restaurant r) {
    if (r.status == RestaurantStatus.approved) {
      all.insert(0, r);
    } else {
      pending.insert(0, r);
    }

    notifyListeners();
  }

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

  // ---------- Restoran favorit ----------

  bool isSaved(String id) => saved.contains(id);

  void toggleSaved(String id) {
    saved.contains(id) ? saved.remove(id) : saved.add(id);
    notifyListeners();
  }
}
