
import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../data/models/menu_item.dart';
import '../services/menu_api_service.dart';

class MenuProvider extends ChangeNotifier {
  // Data lokal tetap dipertahankan untuk fitur admin.
  final List<MenuItem> items = DummyData.menus();

  final MenuApiService _menuApiService = MenuApiService();

  // Menyimpan menu API berdasarkan ID restoran.
  final Map<String, List<MenuItem>> _apiMenus = {};
  final Set<String> _loadingRestaurants = {};
  final Map<String, String> _apiErrors = {};

  String adminQuery = '';
  String adminCategory = 'Semua';

  bool isLoadingForRestaurant(String id) {
    return _loadingRestaurants.contains(id);
  }

  String? errorForRestaurant(String id) {
    return _apiErrors[id];
  }

  Future<void> loadMenusForRestaurant(String restaurantId) async {
    final id = restaurantId.trim();

    // Data restoran dari API menggunakan ID numerik.
    if (int.tryParse(id) == null) return;

    if (_loadingRestaurants.contains(id)) return;
    if (_apiMenus.containsKey(id)) return;

    _loadingRestaurants.add(id);
    _apiErrors.remove(id);
    notifyListeners();

    try {
      final data = await _menuApiService.fetchMenus(id);

      final List<MenuItem> hasil = data.map((item) {
        final json = Map<String, dynamic>.from(item as Map);

        int toInt(dynamic value) {
          if (value is num) return value.toInt();
          return int.tryParse(value?.toString() ?? '') ?? 0;
        }

        double toDouble(dynamic value) {
          if (value is num) return value.toDouble();
          return double.tryParse(value?.toString() ?? '') ?? 0.0;
        }

        String toText(dynamic value, [String fallback = '']) {
          final text = value?.toString().trim() ?? '';
          return text.isEmpty ? fallback : text;
        }

        final namaGambar = toText(json['gambar']).toLowerCase();

        const gambarLokal = <String, String>{
          'menu_gohu.jpg': 'assets/images/menu_gohu.jpg',
          'menu_fufu.jpg': 'assets/images/menu_fufu.jpg',
          'menu_guraka.jpg': 'assets/images/menu_guraka.jpg',
          'menu_pisang.jpg': 'assets/images/menu_pisang.jpg',
          'menu_popeda.jpg': 'assets/images/menu_popeda.jpg',
        };

        return MenuItem(
          id: toText(json['id']),
          restaurantId: toText(json['restaurant_id'], id),
          name: toText(json['nama'], 'Menu tanpa nama'),
          description: toText(
            json['deskripsi'],
            toText(json['kategori'], 'Menu restoran'),
          ),
          price: toInt(json['harga']),
          category: toText(json['kategori'], 'Lainnya'),
          image: gambarLokal[namaGambar],
          rating: toDouble(json['rating']),
          reviews: toInt(json['jumlah_ulasan']),
          available: true,
        );
      }).toList();

      _apiMenus[id] = hasil;

      debugPrint('Menu API restoran $id berhasil dimuat.');
      debugPrint('Jumlah menu: ${hasil.length}');

      for (final menu in hasil) {
        debugPrint('${menu.name} - Rp${menu.price}');
      }
    } catch (e) {
      _apiErrors[id] = e.toString();
      debugPrint('Gagal mengambil menu restoran $id: $e');
    } finally {
      _loadingRestaurants.remove(id);
      notifyListeners();
    }
  }

  // ID numerik mengambil menu dari API.
  // ID nonnumerik tetap menggunakan data lokal.
  List<MenuItem> forRestaurant(String restaurantId) {
    final id = restaurantId.trim();

    if (int.tryParse(id) != null) {
      return _apiMenus[id] ?? [];
    }

    return items.where((menu) => menu.restaurantId == id).toList();
  }

  List<MenuItem> get adminList {
    return items.where((menu) {
      final query = adminQuery.trim().toLowerCase();

      final cocokNama =
          query.isEmpty || menu.name.toLowerCase().contains(query);

      final cocokKategori = adminCategory == 'Semua' ||
          menu.category.toLowerCase().contains(
                adminCategory.toLowerCase(),
              );

      return cocokNama && cocokKategori;
    }).toList();
  }

  int get total => items.length;

  int get availableCount =>
      items.where((menu) => menu.available).length;

  int get soldOut => total - availableCount;

  void setAdminQuery(String value) {
    adminQuery = value;
    notifyListeners();
  }

  void setAdminCategory(String value) {
    adminCategory = value;
    notifyListeners();
  }

  void toggle(MenuItem menu) {
    menu.available = !menu.available;
    menu.badge = menu.available
        ? (menu.badge == 'HABIS' ? null : menu.badge)
        : 'HABIS';

    notifyListeners();
  }

  void add(MenuItem menu) {
    items.insert(0, menu);
    notifyListeners();
  }

  void update(
    MenuItem menu,
    String name,
    int price,
    String category,
    String description,
  ) {
    menu.name = name;
    menu.price = price;
    menu.category = category;
    menu.description = description;

    notifyListeners();
  }

  void remove(MenuItem menu) {
    items.remove(menu);
    notifyListeners();
  }
}