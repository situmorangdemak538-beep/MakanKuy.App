class Review {
  final int id;
  final int restaurantId;
  final String userName;
  final double rating;
  final String comment;

  const Review({
    required this.id,
    required this.restaurantId,
    required this.userName,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: int.tryParse('${json['id']}') ?? 0,
      restaurantId:
          int.tryParse('${json['restaurant_id']}') ?? 0,
      userName: '${json['user_name'] ?? ''}',
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
      comment: '${json['comment'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
    };
  }
}