import '../models/user_model.dart';

class AuthService {
  User? _currentUser;

  Future<User> login(
    String email,
    String password,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );

    final role = email.toLowerCase().contains('admin')
        ? 'restaurant_admin'
        : 'customer';

    _currentUser = User(
      id: 1,
      name: role == 'restaurant_admin'
          ? 'Admin Restoran'
          : 'Pelanggan MakanKuy',
      email: email,
      role: role,
    );

    return _currentUser!;
  }

  Future<User> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );

    _currentUser = User(
      id: 1,
      name: name,
      email: email,
      role: role,
    );

    return _currentUser!;
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  User? get currentUser => _currentUser;
}