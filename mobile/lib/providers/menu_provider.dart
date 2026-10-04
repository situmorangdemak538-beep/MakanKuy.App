import 'package:flutter/foundation.dart';
import 'package:makankuy/models/menu_model.dart';
import 'package:makankuy/services/menu_service.dart';

class MenuProvider extends ChangeNotifier {
  final MenuService _service = MenuService();

  List<MenuModel> menus = [];
  bool loading = false;

  Future<void> loadMenus(int restaurantId) async {
    loading = true;
    notifyListeners();

    try {
      menus = await _service.getMenus(restaurantId);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}