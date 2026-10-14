import 'package:flutter/foundation.dart';

import '../data/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  // Menyimpan informasi akun yang sedang login.
  UserProfile? user;

  // Menandai apakah proses login sedang berlangsung.
  bool loading = false;

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

  /// Memperbarui nama dan nomor telepon akun.
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
