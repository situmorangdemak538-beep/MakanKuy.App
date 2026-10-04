import 'package:makankuy/models/menu_model.dart';

class MenuService {
  Future<List<MenuModel>> getMenus(int restaurantId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return [
      MenuModel(
        id: 1,
        restaurantId: restaurantId,
        name: 'Gohu Ikan Cakalang Segar',
        description:
            'Gohu ikan dengan bumbu khas, segar, gurih, dan cocok untuk makan bersama.',
        price: 35000,
        category: 'Makanan',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554',
        popular: true,
      ),
      MenuModel(
        id: 2,
        restaurantId: restaurantId,
        name: 'Ikan Bakar Rempah',
        description:
            'Ikan bakar dengan bumbu rempah dan sambal khas daerah.',
        price: 55000,
        category: 'Seafood',
        imageUrl:
            'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2',
        popular: true,
      ),
      MenuModel(
        id: 3,
        restaurantId: restaurantId,
        name: 'Nasi Rempah Ayam',
        description: 'Nasi berbumbu dengan ayam dan sambal pilihan.',
        price: 30000,
        category: 'Makanan',
        imageUrl:
            'https://images.unsplash.com/photo-1512058564366-18510be2db19',
        popular: false,
      ),
    ];
  }
}