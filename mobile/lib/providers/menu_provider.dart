import 'package:flutter/foundation.dart';
import '../data/dummy_data.dart';
import '../data/models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  final List<MenuItem> items = DummyData.menus();

  String adminQuery = '';
  String adminCategory = 'Semua';

  /// DUMMY: nanti GET /api/restaurants/{id}/menus
  List<MenuItem> forRestaurant(String id) {
    final l = items.where((m) => m.restaurantId == id).toList();
    return l.isEmpty ? items.where((m) => m.restaurantId == 'r1').toList() : l;
  }

  List<MenuItem> get adminList => items.where((m) {
        final q = adminQuery.trim().toLowerCase();
        final okQ = q.isEmpty || m.name.toLowerCase().contains(q);
        final okC = adminCategory == 'Semua' ||
            m.category.toLowerCase().contains(adminCategory.toLowerCase());
        return okQ && okC;
      }).toList();

  int get total => items.length;
  int get availableCount => items.where((m) => m.available).length;
  int get soldOut => total - availableCount;

  void setAdminQuery(String v) {
    adminQuery = v;
    notifyListeners();
  }

  void setAdminCategory(String v) {
    adminCategory = v;
    notifyListeners();
  }

  void toggle(MenuItem m) {
    m.available = !m.available;
    m.badge = m.available ? (m.badge == 'HABIS' ? null : m.badge) : 'HABIS';
    notifyListeners();
  }

  void add(MenuItem m) {
    items.insert(0, m);
    notifyListeners();
  }

  void update(MenuItem m, String name, int price, String category, String desc) {
    m.name = name;
    m.price = price;
    m.category = category;
    m.description = desc;
    notifyListeners();
  }

  void remove(MenuItem m) {
    items.remove(m);
    notifyListeners();
  }
}