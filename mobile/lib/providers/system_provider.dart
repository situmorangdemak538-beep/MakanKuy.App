import 'package:flutter/foundation.dart';
import '../data/models/system_models.dart';
import '../data/models/user_profile.dart';

/// Data sistem yang hanya dikelola Administrator (DUMMY).
class SystemProvider extends ChangeNotifier {
  final List<AppUser> users = [
    AppUser('u1', 'Farhan Abdurrahman', 'farhan.ternate@gmail.com', AppRole.customer, '12 Agu 2026'),
    AppUser('u2', 'Siti Rahmawati', 'siti.rahma@gmail.com', AppRole.customer, '20 Agu 2026'),
    AppUser('u3', 'dr. Hendra Malik', 'hendra.malik@gmail.com', AppRole.customer, '02 Sep 2026'),
    AppUser('u4', 'Ibu Nurul Halil', 'nurul.halil@gmail.com', AppRole.customer, '15 Sep 2026'),
    AppUser('u5', 'Admin Gamalama', 'admin@makankuy.id', AppRole.admin, '01 Agu 2026'),
    AppUser('u6', 'Pak Hasan Tidore', 'hasan.tidore@gmail.com', AppRole.admin, '25 Sep 2026'),
    AppUser('u7', 'Ibu Ratna Salero', 'ratna.salero@gmail.com', AppRole.admin, '28 Sep 2026'),
    AppUser('u8', 'Pak Dedy Ternate', 'dedy.ternate@gmail.com', AppRole.customer, '03 Okt 2026', blocked: true),
  ];

  final List<String> categories = [
    'Gohu Ikan',
    'Ikan Fufu',
    'Seafood Bakar',
    'Kuliner Tradisional',
    'Cafe & Kopi',
    'Kedai Wedang',
  ];

  int countRole(AppRole r) => users.where((u) => u.role == r).length;

  /// DUMMY. Backend: PUT /api/users/{id}/block
  void toggleBlock(AppUser u) {
    u.blocked = !u.blocked;
    notifyListeners();
  }

  /// DUMMY. Backend: POST /api/categories
  void addCategory(String name) {
    final n = name.trim();
    if (n.isEmpty || categories.contains(n)) return;
    categories.add(n);
    notifyListeners();
  }

  /// DUMMY. Backend: PUT /api/categories/{id}
  void renameCategory(int i, String name) {
    final n = name.trim();
    if (n.isEmpty) return;
    categories[i] = n;
    notifyListeners();
  }

  /// DUMMY. Backend: DELETE /api/categories/{id}
  void removeCategory(int i) {
    categories.removeAt(i);
    notifyListeners();
  }
}