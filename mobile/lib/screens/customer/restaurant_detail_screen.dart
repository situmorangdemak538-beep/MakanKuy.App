import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/dummy_data.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/restaurant.dart';
import '../../providers/menu_provider.dart';
import 'menu_detail_screen.dart';
import 'reservation_form_screen.dart';

void openRestaurant(BuildContext context, Restaurant r) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r)));
}

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});
  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  int _cat = 0;
  static const _cats = ['Menu Favorit', 'Makanan Utama', 'Minuman Tradisional'];

  List<MenuItem> _filter(List<MenuItem> l) {
    switch (_cat) {
      case 1:
        return l.where((m) => m.category != 'Minuman Tradisional' && m.category != 'Camilan').toList();
      case 2:
        return l.where((m) => m.category == 'Minuman Tradisional').toList();
      default:
        return l.where((m) => m.rating >= 4.8 || m.badge != null).toList();
    }
  }

  Widget _facility(IconData i, String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: box(color: AppColors.surface, r: 14),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(i, color: AppColors.primaryDark, size: 22),
          gap(4),
          Text(t, style: ts(11, w: FontWeight.w600), textAlign: TextAlign.center),
        ]),
      );

  Widget _bar(String label, double v) => Row(children: [
        SizedBox(width: 12, child: Text(label, style: ts(11, c: AppColors.muted))),
        gapW(8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: AppColors.border,
                color: AppColors.amber),
          ),
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    final menus = _filter(context.watch<MenuProvider>().forRestaurant(r.id));

    return Scaffold(
      body: Column(children: [
        DetailTopBar(
          title: 'Detail Restoran',
          onShare: () => Share.share(
              '${r.name} - ${r.address}. Cek di aplikasi MakanKuy!'),
        ),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            // Hero
            SizedBox(
              height: 250,
              child: Stack(fit: StackFit.expand, children: [
                FoodImage(path: r.image, radius: 0),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC000000)]),
                  ),
                ),
                Positioned(
                    left: 14,
                    top: 14,
                    child: Pill(
                        text: '${r.rating} (${r.reviews} ulasan)',
                        bg: Colors.white.withAlpha(230),
                        icon: Icons.star_rounded,
                        fg: AppColors.ink)),
                const Positioned(
                    right: 14,
                    top: 14,
                    child: Pill(
                        text: 'Buka • Meja Tersedia',
                        bg: AppColors.greenSoft,
                        fg: AppColors.green)),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (r.badge != null)
                      Pill(
                          text: r.badge!,
                          bg: AppColors.amber,
                          fg: const Color(0xFF4A2F00),
                          icon: Icons.verified_outlined),
                    gap(6),
                    Text(r.name,
                        style: ts(24, w: FontWeight.w800, c: Colors.white, h: 1.15)),
                  ]),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Wrap(spacing: 8, runSpacing: 8, children: [
                  Pill(text: 'Kuliner Asli Ternate', bg: AppColors.peach, fg: AppColors.primaryDark, icon: Icons.restaurant, fontSize: 12),
                  Pill(text: 'Seafood Segar', bg: AppColors.greenSoft, fg: AppColors.green, icon: Icons.set_meal_rounded, fontSize: 12),
                  Pill(text: '100% Halal', bg: AppColors.amberSoft, fg: Color(0xFF6B4400), icon: Icons.verified_outlined, fontSize: 12),
                ]),
                gap(16),
                // Lokasi
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: box(color: AppColors.surface, r: 22),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: AppColors.peach, shape: BoxShape.circle),
                        child: const Icon(Icons.location_on_outlined,
                            color: AppColors.primaryDark),
                      ),
                      gapW(12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(
                                child: Text('Gamalama, ${r.area}',
                                    style: ts(14, w: FontWeight.w800))),
                            Text('${r.distanceKm} km dari lokasimu',
                                style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark)),
                          ]),
                          gap(2),
                          Text(r.address, style: ts(12, c: AppColors.muted, h: 1.4)),
                        ]),
                      ),
                    ]),
                    gap(12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 110,
                        color: const Color(0xFFCFE8F5),
                        child: Stack(children: [
                          const Center(
                              child: Icon(Icons.map_outlined,
                                  size: 54, color: Colors.white70)),
                          Positioned(
                              left: 8,
                              bottom: 8,
                              child: Pill(
                                  text: '${r.driveMinutes} menit berkendara',
                                  bg: AppColors.amberSoft,
                                  fg: const Color(0xFF6B4400),
                                  icon: Icons.warning_amber_rounded)),
                          Positioned(
                              right: 8,
                              bottom: 8,
                              child: GestureDetector(
                                onTap: () => toast(context, 'Membuka petunjuk arah...'),
                                child: const Pill(
                                    text: 'Buka Petunjuk Arah',
                                    bg: Colors.white,
                                    fg: AppColors.ink,
                                    icon: Icons.open_in_new_rounded),
                              )),
                        ]),
                      ),
                    ),
                  ]),
                ),
                gap(12),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: box(color: AppColors.surface, r: 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primaryDark),
                          gapW(6),
                          Text('Jam Operasional', style: ts(12, c: AppColors.muted)),
                        ]),
                        gap(8),
                        Text(r.hours, style: ts(14, w: FontWeight.w800)),
                        Text('Buka Setiap Hari',
                            style: ts(12, w: FontWeight.w700, c: AppColors.green)),
                      ]),
                    ),
                  ),
                  gapW(12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: box(color: AppColors.surface, r: 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Icon(Icons.chat_outlined, size: 16, color: AppColors.primaryDark),
                          gapW(6),
                          Text('Kontak Langsung', style: ts(12, c: AppColors.muted)),
                        ]),
                        gap(8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => toast(context, 'Membuka WhatsApp ${r.whatsapp}'),
                            icon: const Icon(Icons.call, size: 16),
                            label: Text('WhatsApp\nKedai',
                                style: ts(12, w: FontWeight.w800, c: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ]),
                gap(20),
                Text('Fasilitas Kedai', style: ts(17, w: FontWeight.w800)),
                gap(10),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _facility(Icons.wifi_rounded, 'WiFi Gratis'),
                    _facility(Icons.deck_rounded, 'Area Lesehan'),
                    _facility(Icons.landscape_rounded, 'View Gamalama'),
                    _facility(Icons.mosque_outlined, 'Musholla'),
                    _facility(Icons.local_parking_rounded, 'Parkir Luas'),
                  ],
                ),
                gap(20),
                SectionTitle(title: 'Daftar Menu Spesial', action: 'Lihat Semua', onAction: () => setState(() => _cat = 0)),
                gap(10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (var i = 0; i < _cats.length; i++) ...[
                      FilterPill(
                          label: _cats[i],
                          selected: _cat == i,
                          selBg: AppColors.primary,
                          onTap: () => setState(() => _cat = i)),
                      gapW(8),
                    ],
                  ]),
                ),
                gap(12),
                if (menus.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Text('Menu belum tersedia',
                            style: ts(13, c: AppColors.muted))),
                  ),
                ...menus.map((m) => GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MenuDetailScreen(menu: m, restaurant: r))),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: box(color: AppColors.surface, r: 20),
                        child: Row(children: [
                          Stack(children: [
                            FoodImage(path: m.image, width: 78, height: 86, radius: 14),
                            if (m.category == 'Menu Khas Ternate')
                              const Positioned(
                                  left: 4,
                                  top: 4,
                                  child: Pill(
                                      text: 'Khas Ternate',
                                      bg: AppColors.amber,
                                      fg: Color(0xFF4A2F00),
                                      fontSize: 9)),
                          ]),
                          gapW(12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(m.name, style: ts(14, w: FontWeight.w800)),
                              Text(m.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: ts(11, c: AppColors.muted, h: 1.35)),
                              gap(4),
                              Text(rupiah(m.price),
                                  style: ts(14, w: FontWeight.w800, c: AppColors.primaryDark)),
                            ]),
                          ),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                                color: AppColors.peach, shape: BoxShape.circle),
                            child: const Icon(Icons.add_rounded,
                                color: AppColors.primaryDark),
                          ),
                        ]),
                      ),
                    )),
                gap(14),
                SectionTitle(
                    title: 'Ulasan Pelanggan',
                    subtitle: 'Pengalaman bersantap warga & wisatawan',
                    action: 'Tulis Ulasan',
                    onAction: () => toast(context, 'Form ulasan segera hadir')),
                gap(12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: box(color: AppColors.surface, r: 22),
                  child: Row(children: [
                    Column(children: [
                      Text('${r.rating}', style: ts(42, w: FontWeight.w800, c: AppColors.primaryDark)),
                      Row(children: List.generate(5, (_) => const Icon(Icons.star_rounded, size: 16, color: AppColors.amber))),
                      gap(4),
                      Text('${r.reviews} Review', style: ts(11, w: FontWeight.w700)),
                    ]),
                    gapW(20),
                    Expanded(
                      child: Column(children: [
                        _bar('5', 0.9),
                        gap(6),
                        _bar('4', 0.07),
                        gap(6),
                        _bar('3', 0.03),
                      ]),
                    ),
                  ]),
                ),
                gap(12),
                ...DummyData.reviews.map((v) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: box(color: AppColors.surface, r: 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.amberSoft,
                              child: Text(v.initials, style: ts(12, w: FontWeight.w800))),
                          gapW(10),
                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(v.name, style: ts(13, w: FontWeight.w800)),
                            Text(v.ago, style: ts(11, c: AppColors.muted)),
                          ])),
                          Row(children: List.generate(v.rating, (_) => const Icon(Icons.star_rounded, size: 14, color: AppColors.amber))),
                        ]),
                        gap(8),
                        Text('"${v.text}"', style: ts(12, c: AppColors.muted, h: 1.5)),
                      ]),
                    )),
                gap(10),
              ]),
            ),
          ]),
        ),
        // Bottom bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 16, offset: const Offset(0, -4)),
          ]),
          child: SafeArea(
            top: false,
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.circle, size: 9, color: AppColors.green),
                    gapW(6),
                    Text('${r.tablesFree} Meja Kosong',
                        style: ts(13, w: FontWeight.w800)),
                  ]),
                  Text('Sesi Malam (18:00 - 21:00 WIT)',
                      style: ts(11, c: AppColors.muted)),
                ]),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => openReservation(context, r),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  iconAlignment: IconAlignment.end,
                  label: Text('Reservasi Meja',
                      style: ts(14, w: FontWeight.w800, c: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      shape: const StadiumBorder()),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}