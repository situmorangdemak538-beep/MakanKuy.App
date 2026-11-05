
enum RestaurantStatus { pending, approved, rejected }

class Restaurant {
  final String id, name, category, area, address, image;
  final double distanceKm, rating;
  final int reviews, priceFrom, priceTo, tablesFree, driveMinutes;
  final String priceNote, specialtyLabel, specialty, hours, whatsapp;
  final String? badge, highlight;
  final List<String> tags;
  final bool isPopular, isNearby;

  // Data warung
  final int totalTables, seatsPerTable;
  final String openTime, closeTime, ownerName, description;
  final List<String> openDays, facilities;
  RestaurantStatus status;

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
    this.totalTables = 10,
    this.seatsPerTable = 4,
    this.openTime = '10:00',
    this.closeTime = '22:00',
    this.openDays = const [
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ],
    this.facilities = const [],
    this.ownerName = '',
    this.description = '',
    this.status = RestaurantStatus.approved,
  }) : priceTo = priceTo ?? priceFrom;

  /// Mengubah data JSON Laravel menjadi objek Restaurant.
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value, {int fallback = 0}) {
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }

    double toDouble(dynamic value, {double fallback = 0}) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? fallback;
    }

    String toText(dynamic value, {String fallback = ''}) {
      final text = value?.toString().trim() ?? '';
      return text.isEmpty ? fallback : text;
    }

    final nama = toText(
      json['nama'],
      fallback: 'Restoran tanpa nama',
    );

    final hargaRataRata = toInt(json['harga_rata_rata']);

    final hargaMin = toInt(
      json['harga_min'],
      fallback: hargaRataRata,
    );

    final hargaMax = toInt(
      json['harga_max'],
      fallback: hargaRataRata > 0 ? hargaRataRata : hargaMin,
    );

    final jamBuka = toText(json['jam_buka'], fallback: '10:00');
    final jamTutup = toText(json['jam_tutup'], fallback: '22:00');

    final statusApi = toText(
      json['status'],
      fallback: 'approved',
    ).toLowerCase();

    // Pilih gambar lokal berdasarkan nama restoran.
    final namaLower = nama.toLowerCase();

    String gambarLokal;

    if (namaLower.contains('gamalama')) {
      gambarLokal = 'assets/images/resto_gamalama.jpg';
    } else if (namaLower.contains('fufu')) {
      gambarLokal = 'assets/images/resto_fufu.jpg';
    } else if (namaLower.contains('sagu') ||
        namaLower.contains('kasbi cengkeh')) {
      gambarLokal = 'assets/images/resto_sagu.jpg';
    } else if (namaLower.contains('guraka') ||
        namaLower.contains('mulut bebek')) {
      gambarLokal = 'assets/images/resto_guraka.jpg';
    } else if (namaLower.contains('mama etha')) {
      gambarLokal = 'assets/images/resto_mama_etha.jpg';
    } else if (namaLower.contains('popeda')) {
      gambarLokal = 'assets/images/resto_popeda.jpg';
    } else if (namaLower.contains('falajawa')) {
      gambarLokal = 'assets/images/resto_falajawa.jpg';
    } else if (namaLower.contains('fort oranje')) {
      gambarLokal = 'assets/images/resto_fort.jpg';
    } else {
      gambarLokal = 'assets/images/resto_default.jpg';
    }

    return Restaurant(
      id: toText(json['id'], fallback: ''),
      name: nama,
      category: toText(json['kategori'], fallback: 'Umum'),
      area: toText(json['area'], fallback: 'Ternate Tengah'),
      address: toText(
        json['alamat'],
        fallback: 'Alamat belum tersedia',
      ),
      image: gambarLokal,
      distanceKm: 0,
      rating: toDouble(json['rating']),
      reviews: toInt(json['jumlah_ulasan']),
      priceFrom: hargaMin,
      priceTo: hargaMax,
      tablesFree: 0,
      specialty: toText(
        json['deskripsi'],
        fallback: 'Menu belum tersedia',
      ),
      description: toText(json['deskripsi']),
      openTime: jamBuka,
      closeTime: jamTutup,
      hours: '$jamBuka - $jamTutup WIT',
      status: statusApi == 'pending'
          ? RestaurantStatus.pending
          : statusApi == 'rejected'
              ? RestaurantStatus.rejected
              : RestaurantStatus.approved,
    );
  }

  String get distanceLabel => distanceKm < 1
      ? '${(distanceKm * 1000).round()}m'
      : '${distanceKm.toStringAsFixed(1)} km';
}

class Review {
  final String name, initials, text, ago;
  final int rating;

  const Review(
    this.name,
    this.initials,
    this.rating,
    this.text,
    this.ago,
  );
}