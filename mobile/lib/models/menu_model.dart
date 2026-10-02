class Menu {
  final int id;
  final int restaurantId;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String category;
  final bool isPopular;

  const Menu({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.isPopular,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: int.tryParse('${json['id']}') ?? 0,
      restaurantId: int.tryParse('${json['restaurant_id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      imageUrl: '${json['image_url'] ?? ''}',
      price: double.tryParse('${json['price'] ?? 0}') ?? 0,
      description: '${json['description'] ?? ''}',
      category: '${json['category'] ?? ''}',
      isPopular: json['is_popular'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'description': description,
      'category': category,
      'is_popular': isPopular,
    };
  }
}