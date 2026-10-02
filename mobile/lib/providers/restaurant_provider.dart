import 'package:flutter/foundation.dart';

import '../models/restaurant_model.dart';
import '../services/restaurant_service.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantService _service = RestaurantService();

  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _error;

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRestaurants({
    String search = '',
    String category = '',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _restaurants = await _service.getRestaurants(
        search: search,
        category: category,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}