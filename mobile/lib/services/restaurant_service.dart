import '../models/restaurant_model.dart';

class RestaurantService {
  Future<List<Restaurant>> getRestaurants({
    String search = '',
    String category = '',
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 250),
    );

    final data = <Restaurant>[
      const Restaurant(
        id: 1,
        name: 'MakanKuy Resto',
        imageUrl: '',
        rating: 4.8,
        address: 'Ternate, Maluku Utara',
        openingHours: '10:00 - 22:00',
        description:
            'Restoran lokal dengan pilihan makanan yang cocok untuk keluarga dan teman.',
        category: 'Nusantara',
        averagePrice: 'Rp25.000 - Rp75.000',
      ),
      const Restaurant(
        id: 2,
        name: 'Rasa Bahari',
        imageUrl: '',
        rating: 4.6,
        address: 'Ternate, Maluku Utara',
        openingHours: '09:00 - 21:00',
        description:
            'Tempat makan dengan menu olahan laut dan makanan khas daerah.',
        category: 'Seafood',
        averagePrice: 'Rp30.000 - Rp90.000',
      ),
      const Restaurant(
        id: 3,
        name: 'Kedai Rempah',
        imageUrl: '',
        rating: 4.5,
        address: 'Ternate, Maluku Utara',
        openingHours: '11:00 - 23:00',
        description:
            'Kedai dengan menu sederhana, harga terjangkau, dan suasana santai.',
        category: 'Kedai',
        averagePrice: 'Rp15.000 - Rp50.000',
      ),
    ];

    final normalizedSearch = search.trim().toLowerCase();
    return data.where((restaurant) {
      final matchesSearch = normalizedSearch.isEmpty ||
          restaurant.name.toLowerCase().contains(
                normalizedSearch,
              ) ||
          restaurant.address.toLowerCase().contains(
                normalizedSearch,
              );

      final matchesCategory = category.isEmpty ||
          restaurant.category == category;

      return matchesSearch && matchesCategory;
    }).toList();
  }
}