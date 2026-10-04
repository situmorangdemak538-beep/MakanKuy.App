import 'package:makankuy/models/restaurant_model.dart';

class RestaurantService {
  Future<List<RestaurantModel>> getRestaurants() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return const [
      RestaurantModel(
        id: 1,
        name: 'Rumah Makan Gohu Ikan Gamalama',
        category: 'Seafood',
        address: 'Gamalama, Ternate',
        description:
            'Restoran lokal dengan pilihan makanan khas Maluku Utara, suasana nyaman, dan cocok untuk keluarga.',
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
        openingHours: '10:00 - 22:00 WIT',
        rating: 4.9,
        distance: 1.2,
        averagePrice: 50000,
      ),
      RestaurantModel(
        id: 2,
        name: 'Dapur Ikan Fufu Dodoku',
        category: 'Nusantara',
        address: 'Ternate Selatan',
        description:
            'Pilihan menu lokal dan seafood dengan rasa khas serta harga yang terjangkau.',
        imageUrl:
            'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f',
        openingHours: '09:00 - 21:00 WIT',
        rating: 4.7,
        distance: 2.3,
        averagePrice: 45000,
      ),
      RestaurantModel(
        id: 3,
        name: 'Kedai Rempah Ternate',
        category: 'Kedai',
        address: 'Ternate Tengah',
        description:
            'Kedai santai dengan menu makanan dan minuman untuk berkumpul bersama teman.',
        imageUrl:
            'https://images.unsplash.com/photo-1552566626-52f8b828add9',
        openingHours: '11:00 - 23:00 WIT',
        rating: 4.6,
        distance: 3.1,
        averagePrice: 30000,
      ),
    ];
  }
}