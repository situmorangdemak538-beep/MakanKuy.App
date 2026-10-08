class MenuItem {
  final String id, restaurantId;
  String name, description, category, tagline;
  int price;
  String? image, badge;
  double rating;
  int reviews;
  bool available;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.tagline = '',
    this.image,
    this.badge,
    this.rating = 4.8,
    this.reviews = 0,
    this.available = true,
  });
}