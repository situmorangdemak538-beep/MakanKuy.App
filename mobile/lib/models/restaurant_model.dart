class RestaurantModel {
  final int id;
  final String name;
  final String category;
  final String address;
  final String description;
  final String imageUrl;
  final String openingHours;
  final double rating;
  final double distance;
  final int averagePrice;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.openingHours,
    required this.rating,
    required this.distance,
    required this.averagePrice,
  });
}