import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../providers/nav_provider.dart';
import '../screens/admin/admin_shell.dart';
import '../screens/customer/customer_shell.dart';
import '../screens/splash_screen.dart';

void goHome(BuildContext context, AppRole role) {
  context.read<NavProvider>().go(0);
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) =>
          role == AppRole.admin ? const AdminShell() : const CustomerShell(),
    ),
    (_) => false,
  );
}

void logoutToSplash(BuildContext context) {
  context.read<AuthProvider>().logout();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const SplashScreen()),
    (_) => false,
  );
}