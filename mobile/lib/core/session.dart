import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../providers/nav_provider.dart';
import '../screens/admin/admin_shell.dart';
import '../screens/customer/customer_shell.dart';
import '../screens/splash_screen.dart';

/// Membuka halaman utama sesuai role akun.
void goHome(BuildContext context, AppRole role) {
  // Mengatur navigasi ke halaman pertama.
  context.read<NavProvider>().go(0);

  // Menghapus halaman sebelumnya agar tombol Back
  // tidak kembali ke halaman login.
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) {
        // Admin restoran membuka navigasi admin.
        if (role == AppRole.admin) {
          return const AdminShell();
        }

        // Pengguna membuka navigasi customer.
        return const CustomerShell();
      },
    ),
    (route) => false,
  );
}

/// Logout dan kembali ke halaman splash.
void logoutToSplash(BuildContext context) {
  // Hapus akun yang sedang login.
  context.read<AuthProvider>().logout();

  // Kembali ke splash dan hapus halaman sebelumnya.
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => const SplashScreen(),
    ),
    (route) => false,
  );
}
