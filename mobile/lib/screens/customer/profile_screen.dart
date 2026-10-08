import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/restaurant_provider.dart';
import 'restaurant_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _reminder = true;

  Widget _stat(IconData i, Color bg, String v, String l) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: box(color: AppColors.surface, r: 20),
          child: Column(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(i, size: 20, color: AppColors.primaryDark),
            ),
            gap(6),
            Text(v, style: ts(22, w: FontWeight.w800)),
            Text(l, textAlign: TextAlign.center, style: ts(10, w: FontWeight.w700, c: AppColors.muted)),
          ]),
        ),
      );

  Widget _menuRow(IconData i, String t, String sub, VoidCallback onTap,
      {bool highlight = false, String? tag}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: box(color: highlight ? Colors.white : Colors.transparent, r: 16),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: highlight ? AppColors.peach : AppColors.surface, shape: BoxShape.circle),
            child: Icon(i, size: 20, color: highlight ? AppColors.primaryDark : AppColors.muted),
          ),
          gapW(12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: Text(t, style: ts(14, w: FontWeight.w800))),
                if (tag != null) ...[
                  gapW(6),
                  Pill(text: tag, bg: AppColors.green, fg: Colors.white, fontSize: 9),
                ],
              ]),
              Text(sub, style: ts(11, c: AppColors.muted)),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ]),
      ),
    );
  }

  void _edit(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final name = TextEditingController(text: auth.user?.name);
    final phone = TextEditingController(text: auth.user?.phone);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Edit Profil', style: ts(18, w: FontWeight.w800)),
          gap(14),
          TextField(controller: name, decoration: const InputDecoration(hintText: 'Nama lengkap')),
          gap(10),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: 'Nomor WhatsApp')),
          gap(16),
          PrimaryButton(
              label: 'Simpan',
              onPressed: () {
                auth.updateProfile(name.text.trim(), phone.text.trim());
                Navigator.pop(ctx);
              }),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final rp = context.watch<RestaurantProvider>();
    final res = context.watch<ReservationProvider>();
    final favs = rp.all.where((r) => rp.saved.contains(r.id)).toList();
    final doneCount = res.mine.where((r) => r.status.name == 'completed').length + 12;

    return Scaffold(
      body: Column(children: [
        const BrandHeader(eyebrow: 'MAKANKUY TERNATE', title: 'Profil Pengguna'),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: box(color: AppColors.surface, r: 26),
              child: Column(children: [
                Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                    child: const Avatar(size: 92),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
                      child: const Icon(Icons.verified_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ]),
                gap(10),
                Text(user?.name ?? 'Pengguna', style: ts(22, w: FontWeight.w800)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primaryDark),
                  Text(user?.area ?? '', style: ts(12, c: AppColors.muted)),
                ]),
                gap(8),
                Pill(text: user?.level ?? '', bg: AppColors.amberSoft, fg: AppColors.primaryDark, icon: Icons.workspace_premium_outlined, fontSize: 10),
                gap(8),
                Text('${user?.phone ?? ''} • ${user?.email ?? ''}', style: ts(12, c: AppColors.muted)),
                gap(10),
                ElevatedButton.icon(
                  onPressed: () => _edit(context),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text('Edit Profil', style: ts(13, w: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.ink,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: const StadiumBorder()),
                ),
              ]),
            ),
            gap(12),
            Row(children: [
              _stat(Icons.calendar_month_outlined, AppColors.peach, '$doneCount', 'Reservasi\nSukses'),
              gapW(10),
              _stat(Icons.bookmark_border_rounded, AppColors.amberSoft, '${rp.saved.length}', 'Resto Disimpan'),
              gapW(10),
              _stat(Icons.rate_review_outlined, AppColors.greenSoft, '15', 'Ulasan Kuliner'),
            ]),
            gap(20),
            SectionTitle(title: '♡ Restoran Ternate Favorit', action: 'Lihat Semua (${favs.length})'),
            gap(10),
            SizedBox(
              height: 190,
              child: favs.isEmpty
                  ? Center(child: Text('Belum ada restoran favorit', style: ts(13, c: AppColors.muted)))
                  : ListView(scrollDirection: Axis.horizontal, children: [
                      for (final r in favs)
                        GestureDetector(
                          onTap: () => openRestaurant(context, r),
                          child: Container(
                            width: 230,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: box(color: AppColors.surface, r: 20),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Stack(children: [
                                FoodImage(path: r.image, height: 100, width: double.infinity, radius: 14),
                                Positioned(
                                    left: 8,
                                    top: 8,
                                    child: Pill(text: '${r.rating}', bg: Colors.black.withAlpha(130), fg: Colors.white, icon: Icons.star_rounded)),
                                Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Pill(text: r.tablesFree > 0 ? 'Buka' : 'Tutup', bg: AppColors.green, fg: Colors.white)),
                              ]),
                              gap(6),
                              Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(13, w: FontWeight.w800)),
                              Text('${r.area} • ${r.category}', maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(11, c: AppColors.muted)),
                              const Spacer(),
                              Row(children: [
                                Expanded(child: Text('${r.tablesFree} Meja Siap', style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark))),
                                GestureDetector(
                                    onTap: () => rp.toggleSaved(r.id),
                                    child: const Icon(Icons.bookmark_rounded, color: AppColors.primaryDark)),
                              ]),
                            ]),
                          ),
                        ),
                    ]),
            ),
            gap(16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: box(color: AppColors.surface, r: 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.tune_rounded, color: AppColors.primaryDark),
                  gapW(8),
                  Text('Preferensi Kuliner & Reservasi', style: ts(15, w: FontWeight.w800)),
                ]),
                gap(10),
                Text('Cuisine & Menu Favorit', style: ts(12, c: AppColors.muted)),
                gap(8),
                const Wrap(spacing: 8, runSpacing: 8, children: [
                  Pill(text: 'Gohu Ikan', bg: AppColors.peach, fg: AppColors.primaryDark, icon: Icons.restaurant, fontSize: 12),
                  Pill(text: 'Ikan Fufu', bg: AppColors.peach, fg: AppColors.primaryDark, icon: Icons.set_meal_rounded, fontSize: 12),
                  Pill(text: 'Seafood Bakar', bg: AppColors.peach, fg: AppColors.primaryDark, icon: Icons.outdoor_grill_rounded, fontSize: 12),
                  Pill(text: 'Kopi Guraka', bg: AppColors.amberSoft, fg: AppColors.primaryDark, icon: Icons.local_cafe_rounded, fontSize: 12),
                ]),
                gap(12),
                Row(children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
                    child: const Icon(Icons.chat_rounded, color: AppColors.green, size: 20),
                  ),
                  gapW(12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Pengingat WhatsApp', style: ts(14, w: FontWeight.w800)),
                      Text('Kirim konfirmasi H-1 jam ke nomor WA', style: ts(11, c: AppColors.muted)),
                    ]),
                  ),
                  Switch(
                      value: _reminder,
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.green,
                      onChanged: (v) => setState(() => _reminder = v)),
                ]),
                gap(8),
                Row(children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.explore_outlined, color: AppColors.muted, size: 20),
                  ),
                  gapW(12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Wilayah Prioritas', style: ts(14, w: FontWeight.w800)),
                      Text('Ternate Tengah & Ternate Selatan', style: ts(11, c: AppColors.muted)),
                    ]),
                  ),
                  Text('Ubah', style: ts(12, w: FontWeight.w800, c: AppColors.primaryDark)),
                ]),
              ]),
            ),
            gap(14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.surface, r: 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
                  child: Text('Pengaturan & Bantuan', style: ts(16, w: FontWeight.w800)),
                ),
                _menuRow(Icons.notifications_none_rounded, 'Metode Notifikasi', 'WhatsApp & Push App', () => toast(context, 'Segera hadir')),
                _menuRow(Icons.storefront_rounded, 'Daftarkan Warung/Resto Anda', 'Gabung Komunitas Mitra Kuliner MakanKuy', () => toast(context, 'Pendaftaran mitra segera hadir'), highlight: true, tag: 'GRATIS'),
                _menuRow(Icons.support_agent_rounded, 'Pusat Bantuan & Komunitas', 'Bantuan pesan meja & tanya foodie Ternate', () => toast(context, 'Segera hadir')),
                _menuRow(Icons.shield_outlined, 'Syarat & Kebijakan Privasi', 'Informasi penggunaan data & keamanan', () => toast(context, 'Segera hadir')),
              ]),
            ),
            gap(14),
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
            gap(14),
            Center(
              child: Column(children: [
                Text('MakanKuy v2.4.0', style: ts(11, w: FontWeight.w700)),
                Text('Bangga Buatan Ternate, Maluku Utara', style: ts(11, c: AppColors.muted)),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}