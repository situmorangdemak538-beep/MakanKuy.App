import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/auth_provider.dart';
import 'admin_shell.dart';

/// Tab "Toko" - profil restoran (CRUD data restoran: tahap lanjutan)
class AdminStoreScreen extends StatelessWidget {
  const AdminStoreScreen({super.key});

  Widget _row(IconData i, String l, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(i, size: 18, color: AppColors.primaryDark),
          gapW(10),
          SizedBox(width: 90, child: Text(l, style: ts(12, c: AppColors.muted))),
          Expanded(child: Text(v, style: ts(13, w: FontWeight.w800))),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      body: Column(children: [
        const AdminHeader(),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
            Text('Profil Toko', style: ts(22, w: FontWeight.w800)),
            gap(12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: box(color: AppColors.surface, r: 22),
              child: Column(children: [
                _row(Icons.storefront_rounded, 'Nama', 'RM Gohu Ikan Gamalama'),
                _row(Icons.location_on_outlined, 'Alamat', 'Jl. Pahlawan Revolusi No. 42, Ternate Tengah'),
                _row(Icons.schedule_rounded, 'Jam Buka', '10:00 - 22:00 WIT (Setiap Hari)'),
                _row(Icons.chat_outlined, 'WhatsApp', '+62 812-4421-9870'),
                _row(Icons.person_outline_rounded, 'Pengelola', user?.name ?? '-'),
              ]),
            ),
            gap(12),
            PrimaryButton(
                label: 'Edit Data Restoran',
                onPressed: () => toast(context, 'Edit data restoran dikerjakan saat integrasi API')),
            gap(12),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => logoutToSplash(context),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: Text('Keluar dari Akun (Logout)', style: ts(14, w: FontWeight.w800, c: AppColors.red)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redSoft,
                    foregroundColor: AppColors.red,
                    elevation: 0,
                    shape: const StadiumBorder()),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}