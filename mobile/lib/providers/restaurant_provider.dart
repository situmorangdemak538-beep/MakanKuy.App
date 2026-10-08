import 'package:flutter/foundation.dart';
import '../data/dummy_data.dart';
import '../data/models/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {
  final List<Restaurant> all = DummyData.restaurants;

  String query = '';
  String? area = 'Ternate Tengah'; // null = Semua Wilayah
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