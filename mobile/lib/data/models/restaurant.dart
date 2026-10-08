class Restaurant {
  final String id, name, category, area, address, image;
  final double distanceKm, rating;
  final int reviews, priceFrom, priceTo, tablesFree, driveMinutes;
  final String priceNote, specialtyLabel, specialty, hours, whatsapp;
  final String? badge, highlight;
  final List<String> tags;
  final bool isPopular, isNearby;

  Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.address,
    required this.image,
    required this.distanceKm,
    required this.rating,
    required this.reviews,
    required this.priceFrom,
    int? priceTo,
    this.priceNote = '/porsi',
    required this.tablesFree,
    this.specialtyLabel = 'Spesialis',
    required this.specialty,
    this.badge,
    this.highlight,
    this.tags = const [],
    this.isPopular = false,
    this.isNearby = false,
    this.hours = '10:00 - 22:00 WIT',
    this.whatsapp = '+62 812-4421-9870',
    this.driveMinutes = 4,
  }) : priceTo = priceTo ?? priceFrom;

  String get distanceLabel => distanceKm < 1
      ? '${(distanceKm * 1000).round()}m'
      : '${distanceKm.toStringAsFixed(1)} km';
}

class Review {
  final String name, initials, text, ago;
  final int rating;
  const Review(this.name, this.initials, this.rating, this.text, this.ago);
}