import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/models/user_profile.dart';
import '../services/api_config.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? user;
  bool loading = false;
  String? errorMessage;
  String? token;

  static const demoResetCode = '123456';

  // Mengubah role aplikasi menjadi format database.
  String _roleValue(AppRole role) {
    switch (role) {
      case AppRole.customer:
        return 'customer';
      case AppRole.admin:
        return 'admin_resto';
      case AppRole.administrator:
        return 'administrator';
    }
  }

  // Membaca role dari database.
  AppRole _parseRole(String role) {
    switch (role) {
      case 'admin_resto':
        return AppRole.admin;
      case 'administrator':
        return AppRole.administrator;
      default:
        return AppRole.customer;
    }
  }

  // Login melalui Laravel.
  Future<bool> login(
    String email,
    String password,
    AppRole role,
  ) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          'role': _roleValue(role),
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode != 200) {
        errorMessage = result['message'] ?? 'Login gagal.';
        return false;
      }

      final userData = result['user'];
      token = result['token'];

      user = UserProfile(
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? '',
        role: _parseRole(userData['role'] ?? 'customer'),
      );

      return true;
    } catch (e) {
      errorMessage = 'Tidak dapat terhubung ke server.';
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Registrasi dengan role yang dipilih pengguna.
  Future<bool> register(
    String name,
    String phone,
    String email,
    String password, {
    AppRole role = AppRole.customer,
  }) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Administrator tidak boleh mendaftar melalui formulir umum.
      if (role == AppRole.administrator) {
        errorMessage =
            'Akun Administrator harus dibuat melalui proses khusus.';
        return false;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'role': _roleValue(role),
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode != 201) {
        if (result['errors'] is Map &&
            (result['errors'] as Map).isNotEmpty) {
          final errors = result['errors'] as Map;
          final firstError = errors.values.first;

          errorMessage = firstError is List && firstError.isNotEmpty
              ? firstError.first.toString()
              : result['message'] ?? 'Registrasi gagal.';
        } else {
          errorMessage = result['message'] ?? 'Registrasi gagal.';
        }

        return false;
      }

      final userData = result['user'];
      token = result['token'];

      user = UserProfile(
        name: userData['name'] ?? name.trim(),
        email: userData['email'] ?? email.trim(),
        phone: phone.trim(),
        role: _parseRole(userData['role'] ?? _roleValue(role)),
      );

      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = 'Tidak dapat terhubung ke server.';
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Mengambil profil dari database.
  Future<bool> fetchProfile() async {
    if (token == null) {
      errorMessage = 'Token pengguna tidak ditemukan.';
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.profile}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final result = jsonDecode(response.body);

      if (response.statusCode != 200) {
        errorMessage = result['message'] ?? 'Gagal mengambil profil.';
        return false;
      }

      final userData = result['user'];

      user = UserProfile(
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? user?.phone ?? '',
        role: _parseRole(userData['role'] ?? 'customer'),
      );

      errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Tidak dapat mengambil data profil.';
      return false;
    }
  }

  // Memperbarui profil melalui Laravel.
  Future<bool> updateProfile(String name, String phone) async {
    if (token == null) {
      errorMessage = 'Token pengguna tidak ditemukan. Silakan login kembali.';
      return false;
    }

    if (user == null) {
      errorMessage = 'Data pengguna tidak ditemukan.';
      return false;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      const url = '${ApiConfig.baseUrl}${ApiConfig.profile}';

      debugPrint('=== UPDATE PROFILE ===');
      debugPrint('URL: $url');
      debugPrint('Token tersedia: ${token != null}');
      debugPrint('Nama dikirim: ${name.trim()}');
      debugPrint('Telepon dikirim: ${phone.trim()}');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name.trim(),
          'phone': phone.trim(),
        }),
      );

      debugPrint('Status API: ${response.statusCode}');
      debugPrint('Respons API: ${response.body}');

      final result = jsonDecode(response.body);

      if (response.statusCode != 200) {
        errorMessage = result['message'] ?? 'Gagal memperbarui profil.';
        debugPrint('UPDATE PROFILE GAGAL: $errorMessage');
        return false;
      }

      final userData = result['user'];

      user = UserProfile(
        name: userData['name'] ?? name.trim(),
        email: userData['email'] ?? user!.email,
        phone: userData['phone'] ?? phone.trim(),
        role: _parseRole(userData['role'] ?? 'customer'),
      );

      errorMessage = null;
      debugPrint('UPDATE PROFILE BERHASIL');
      return true;
    } catch (e) {
      errorMessage = 'Terjadi kesalahan: $e';
      debugPrint('ERROR UPDATE PROFILE: $e');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Logout melalui Laravel.
  Future<bool> logout() async {
    bool success = false;

    try {
      if (token != null) {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        success = response.statusCode == 200;
      }
    } catch (e) {
      success = false;
    }

    user = null;
    token = null;
    errorMessage = null;
    notifyListeners();

    return success;
  }

  // Meminta kode reset password (demo).
  Future<bool> requestReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  // Memeriksa kode reset password (demo).
  Future<bool> verifyCode(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return code.trim() == demoResetCode;
  }

  // Mengubah password (demo).
  Future<bool> resetPassword(
    String email,
    String code,
    String newPass,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return code.trim() == demoResetCode;
  }

  // Memperbarui data profil lokal.
  void updateProfileLocal(String name, String phone) {
    if (user == null) return;

    user!.name = name;
    user!.phone = phone;
    notifyListeners();
  }
}