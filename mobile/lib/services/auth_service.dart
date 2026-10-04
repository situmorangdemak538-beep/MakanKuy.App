import 'package:makankuy/models/user_model.dart';

class AuthService {
  Future<UserModel> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final lower = email.toLowerCase();

    if (lower.contains('superadmin')) {
      return UserModel(
        id: 3,
        name: 'Administrator',
        email: email,
        role: 'administrator',
      );
    }

    if (lower.contains('admin')) {
      return UserModel(
        id: 2,
        name: 'Admin Restoran',
        email: email,
        role: 'admin',
      );
    }

    return UserModel(
      id: 1,
      name: 'Pelanggan MakanKuy',
      email: email,
      role: 'customer',
    );
  }

  Future<UserModel> register(
    String name,
    String email,
    String password,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return UserModel(
      id: 1,
      name: name,
      email: email,
      role: 'customer',
    );
  }
}