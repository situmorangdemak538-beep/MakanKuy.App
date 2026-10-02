import 'dart:async';

import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
              size: 90,
            ),
            const SizedBox(height: 20),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              AppConstants.slogan,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}