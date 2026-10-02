class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  static String? validateRequired(
    String? value, {
    String message = 'Field wajib diisi',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  const Validators._();
}