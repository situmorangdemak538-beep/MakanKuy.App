import 'package:flutter/foundation.dart';
import '../data/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? user;
  bool loading = false;

  /// Kode verifikasi DEMO untuk lupa sandi. Nanti dikirim backend lewat email.
  static const demoResetCode = '123456';

  /// DUMMY. Backend: POST /api/login  body {email, password, role}
  /// Server wajib memeriksa bahwa role akun di database SAMA dengan role yang dipilih.
  Future<bool> login(String email, String password, AppRole role) async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    user = UserProfile(
      name: switch (role) {
        AppRole.customer => 'Farhan Abdurrahman',
        AppRole.admin => 'Admin Gamalama',
        AppRole.administrator => 'Administrator MakanKuy',
      },
      email: email.trim(),
      phone: '+62 812-4421-9870',
      role: role,
    );
    loading = false;
    notifyListeners();
    return true;
  }

  /// DUMMY. Backend: POST /api/register
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

  /// DUMMY. Backend: POST /api/forgot-password  body {email}
  Future<bool> requestReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  /// DUMMY. Backend: POST /api/verify-reset-code  body {email, code}
  Future<bool> verifyCode(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return code.trim() == demoResetCode;
  }

  /// DUMMY. Backend: POST /api/reset-password  body {email, code, password, password_confirmation}
  Future<bool> resetPassword(String email, String code, String newPass) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return code.trim() == demoResetCode;
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