enum AppRole { customer, admin }

class UserProfile {
  String name;
  String email;
  String phone;
  final AppRole role;
  String area;
  String level;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.area = 'Gamalama, Ternate Tengah',
    this.level = 'Penjelajah Kuliner Ternate • Level 3 (Foodie Lokal)',
  });
}