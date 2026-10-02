import '../models/menu_model.dart';

class MenuService {
  Future<List<Menu>> getMenus(int restaurantId) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 200),
    );

    return <Menu>[
      Menu(
        id: 1,
        restaurantId: restaurantId,
        name: 'Nasi Ayam Rempah',
        imageUrl: '',
        price: 25000,
        description:
            'Nasi dengan ayam dan bumbu rempah khas.',
        category: 'Makanan',
        isPopular: true,
      ),
      Menu(
        id: 2,
        restaurantId: restaurantId,
        name: 'Ikan Bakar',
        imageUrl: '',
        price: 40000,
        description:
            'Ikan bakar dengan sambal dan pelengkap.',
        category: 'Makanan',
        isPopular: true,
      ),
      Menu(
        id: 3,
        restaurantId: restaurantId,
        name: 'Es Teh',
        imageUrl: '',
        price: 8000,
        description: 'Teh dingin sebagai minuman pendamping.',
        category: 'Minuman',
        isPopular: false,
      ),
    ];
  }
}