import 'package:flutter/foundation.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';

class MenuProvider extends ChangeNotifier {
  final MenuService _service = MenuService();

  List<Menu> _menus = [];
  bool _isLoading = false;
  String? _error;

  List<Menu> get menus => _menus;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMenus(int restaurantId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _menus = await _service.getMenus(restaurantId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}