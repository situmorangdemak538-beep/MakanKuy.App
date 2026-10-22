import 'package:flutter/foundation.dart';

import '../data/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  // Menyimpan informasi akun yang sedang login.
  UserProfile? user;

  // Menandai apakah proses login sedang berlangsung.
  bool loading = false;

fitur/tegar
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

  /// Login dummy untuk pengujian aplikasi.
  ///
  /// Email yang diawali "admin" masuk sebagai admin restoran.
  /// Email lainnya masuk sebagai pengguna.
  ///
  /// Catatan: password belum diverifikasi ke database.
  Future<bool> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    // Validasi dasar sebelum memproses login.
    if (cleanEmail.isEmpty || cleanPassword.length < 6) {
      return false;
    }

    loading = true;
    notifyListeners();

    try {
      // Simulasi proses login.
      await Future.delayed(const Duration(milliseconds: 700));

      // Tentukan role akun berdasarkan email.
      final bool isAdmin = cleanEmail.startsWith('admin');

      // Simpan informasi akun beserta role-nya.
      user = UserProfile(
        name: isAdmin ? 'Admin Gamalama' : 'Farhan Abdurrahman',
        email: cleanEmail,
        phone: '+62 812-4421-9870',
        role: isAdmin ? AppRole.admin : AppRole.customer,
      );

      return true;
    } finally {
      // Pastikan loading berhenti dan tampilan diperbarui.
      loading = false;
      notifyListeners();
    }
  }

  /// Registrasi dummy.
  /// Semua akun baru akan mendapatkan role customer.
main
  Future<bool> register(String name, String phone, String email) async {
    final cleanName = name.trim();
    final cleanPhone = phone.trim();
    final cleanEmail = email.trim().toLowerCase();

    // Periksa apakah data wajib sudah diisi.
    if (cleanName.isEmpty || cleanPhone.isEmpty || cleanEmail.isEmpty) {
      return false;
    }

    loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      user = UserProfile(
        name: cleanName,
        email: cleanEmail,
        phone: cleanPhone,
        role: AppRole.customer,
      );

      return true;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

fitur/tegar
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


  /// Memperbarui nama dan nomor telepon akun.
main
  void updateProfile(String name, String phone) {
    if (user == null) return;

    user!.name = name.trim();
    user!.phone = phone.trim();

    notifyListeners();
  }

  /// Menghapus sesi akun saat logout.
  void logout() {
    user = null;
    notifyListeners();
  }
}
