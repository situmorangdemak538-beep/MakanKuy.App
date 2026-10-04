import 'package:flutter/foundation.dart';
import 'package:makankuy/models/user_model.dart';
import 'package:makankuy/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? user;
  bool loading = false;

  Future<bool> login(String email, String password) async {
    loading = true;
    notifyListeners();

    try {
      user = await _service.login(email, password);
      return true;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    loading = true;
    notifyListeners();

    try {
      user = await _service.register(name, email, password);
      return true;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}