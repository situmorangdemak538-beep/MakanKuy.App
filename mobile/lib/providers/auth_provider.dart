import 'package:flutter/foundation.dart';
import '../data/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? user;
  bool loading = false;

  /// DUMMY: nanti diganti POST /api/login (simpan token di local storage)
  Future<bool> login(String email, String password) async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    final isAdmin = email.trim().toLowerCase().startsWith('admin');
    user = UserProfile(
      name: isAdmin ? 'Admin Gamalama' : 'Farhan Abdurrahman',
      email: email.trim(),
      phone: '+62 812-4421-9870',
      role: isAdmin ? AppRole.admin : AppRole.customer,
    );
    loading = false;
    notifyListeners();
    return true;
  }

  /// DUMMY: nanti diganti POST /api/register
  Future<bool> register(String name, String phone, String email) async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    user = UserProfile(
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: AppRole.customer);
    loading = false;
    notifyListeners();
    return true;
  }

  void updateProfile(String name, String phone) {
    if (user == null) return;
    user!.name = name;
    user!.phone = phone;
    notifyListeners();
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}