class MenuModel {
  final int id;
  final int restaurantId;
  final String name;
  final String description;
  final int price;
  final String category;
  final String imageUrl;
  final bool popular;

  const MenuModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.popular,
  });
}