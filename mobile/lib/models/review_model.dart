class ReviewModel {
  final int id;
  final String userName;
  final double rating;
  final String comment;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
  });
}