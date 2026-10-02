class Category {
  final int id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
