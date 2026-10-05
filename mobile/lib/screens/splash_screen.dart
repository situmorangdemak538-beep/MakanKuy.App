import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/common.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _toLogin(BuildContext c) => Navigator.of(c)
      .push(MaterialPageRoute(builder: (_) => const LoginScreen()));

  Widget _chip(IconData i, String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: box(color: AppColors.surface, r: 14),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(i, size: 15, color: AppColors.green),
          gapW(5),
          Text(t, style: ts(11, w: FontWeight.w600)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F8EE),
              borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(400, 60)),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              gap(14),
              const Pill(
                  text: 'Ternate Culinary Hub • Maluku Utara',
                  bg: AppColors.surface,
                  fg: AppColors.primaryDark,
                  icon: Icons.location_on,
                  fontSize: 13),
              gap(12),
              Stack(clipBehavior: Clip.none, children: [
                const AppLogo(size: 128),
                const Positioned(
                  right: -26,
                  bottom: -6,
                  child: Pill(
                      text: 'Asli Ternate',
                      bg: AppColors.amber,
                      fg: Color(0xFF4A2F00),
                      icon: Icons.local_fire_department),
                ),
              ]),
              gap(20),
              Text('MakanKuy',
                  style: ts(44, w: FontWeight.w800, c: AppColors.primaryDark)),
              gap(4),
              const Pill(
                  text: 'SMART UMKM RESERVATION',
                  bg: AppColors.surface,
                  fg: AppColors.primaryDark,
                  fontSize: 11),
              gap(18),
              Text('Cari Restonya, Amankan Mejanya!',
                  textAlign: TextAlign.center,
                  style: ts(26, w: FontWeight.w800, h: 1.2)),
              gap(10),
              Text(
                  'Eksplorasi kuliner khas Ternate & Maluku Utara mulai dari Gohu Ikan legendaris hingga Ikan Fufu asap segar.',
                  textAlign: TextAlign.center,
                  style: ts(14, c: AppColors.muted, h: 1.6)),
              gap(20),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                _chip(Icons.set_meal_rounded, 'Gohu Ikan Tuna'),
                _chip(Icons.event_seat_rounded, 'Booking Instan'),
                _chip(Icons.local_cafe_rounded, 'Air Guraka'),
              ]),
              gap(26),
              PrimaryButton(
                  label: 'Mulai Jelajah Rasa',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => _toLogin(context)),
              gap(16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Sudah punya akun? ', style: ts(14, c: AppColors.muted)),
                GestureDetector(
                  onTap: () => _toLogin(context),
                  child: Text('Masuk',
                      style: ts(14,
                          w: FontWeight.w800, c: AppColors.primaryDark)),
                ),
              ]),
              gap(28),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.verified_outlined,
                    size: 15, color: AppColors.muted),
                gapW(6),
                Text('Didukung Komunitas UMKM Kuliner Ternate',
                    style: ts(11, c: AppColors.muted)),
              ]),
              gap(24),
            ]),
          ),
        ),
      ]),
    );
  }
}