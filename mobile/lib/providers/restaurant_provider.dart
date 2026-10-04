import 'package:flutter/foundation.dart';
import 'package:makankuy/models/restaurant_model.dart';
import 'package:makankuy/services/restaurant_service.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantService _service = RestaurantService();

  List<RestaurantModel> restaurants = [];
  bool loading = false;

  Future<void> loadRestaurants() async {
    loading = true;
    notifyListeners();

    try {
      restaurants = await _service.getRestaurants();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  List<RestaurantModel> search(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      return restaurants;
    }

    return restaurants.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q) ||
          item.address.toLowerCase().contains(q);
    }).toList();
  }
}