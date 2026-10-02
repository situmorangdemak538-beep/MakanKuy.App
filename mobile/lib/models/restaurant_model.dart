class Restaurant {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final String address;
  final String openingHours;
  final String description;
  final String category;
  final String averagePrice;

  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.openingHours,
    required this.description,
    required this.category,
    required this.averagePrice,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      imageUrl: '${json['image_url'] ?? ''}',
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
      address: '${json['address'] ?? ''}',
      openingHours: '${json['opening_hours'] ?? ''}',
      description: '${json['description'] ?? ''}',
      category: '${json['category'] ?? ''}',
      averagePrice: '${json['average_price'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'rating': rating,
      'address': address,
      'opening_hours': openingHours,
      'description': description,
      'category': category,
      'average_price': averagePrice,
    };
  }
}