import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/restaurant.dart';
import '../../providers/nav_provider.dart';
import '../../providers/restaurant_provider.dart';
import 'reservation_form_screen.dart';
import 'restaurant_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _promo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFB8420F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Stack(children: [
        Positioned(
          right: 0,
          top: 0,
          child: Icon(Icons.restaurant_menu_rounded,
              size: 90, color: Colors.white.withAlpha(40)),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Pill(
              text: 'SPESIAL PEKAN INI',
              bg: Colors.white.withAlpha(60),
              fg: Colors.white,
              icon: Icons.local_fire_department),
          gap(10),
          Text('Diskon Meja 25% Hari Ini!',
              style: ts(21, w: FontWeight.w800, c: Colors.white)),
          gap(6),
          Text('Nikmati kuliner legendaris pesisir Ternate bersama kerabat & keluarga tercinta.',
              style: ts(13, c: Colors.white, h: 1.4)),
          gap(14),
          Row(children: [
            ElevatedButton.icon(
              onPressed: () => toast(context, 'Voucher berhasil diklaim!'),
              icon: const Icon(Icons.confirmation_number_outlined, size: 18),
              label: Text('Klaim Voucher',
                  style: ts(13, w: FontWeight.w800, c: AppColors.ink)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.ink,
                  shape: const StadiumBorder()),
            ),
            gapW(12),
            Text('Sisa 8 Kupon', style: ts(12, c: Colors.white)),
          ]),
        ]),
      ]),
    );
  }

  Widget _popularCard(BuildContext context, Restaurant r) {
    return GestureDetector(
      onTap: () => openRestaurant(context, r),
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(8),
        decoration: box(color: AppColors.surface, r: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            FoodImage(
                path: r.image,
                height: 150,
                width: double.infinity,
                radius: 18),
            Positioned(
                left: 8,
                top: 8,
                child: Pill(
                    text: '${r.rating} (${r.reviews})',
                    bg: Colors.white.withAlpha(230),
                    icon: Icons.star_rounded,
                    fg: AppColors.ink)),
            Positioned(
                right: 8,
                top: 8,
                child: Pill(
                    text: '${r.tablesFree} Meja Kosong',
                    bg: AppColors.green,
                    fg: Colors.white)),
          ]),
          gap(8),
          Text(r.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ts(15, w: FontWeight.w800)),
          gap(2),
          Row(children: [
            const Icon(Icons.navigation_outlined, size: 14, color: AppColors.muted),
            gapW(4),
            Expanded(
                child: Text('${r.distanceKm} km • ${r.address}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ts(12, c: AppColors.muted))),
          ]),
          const Spacer(),
          Row(children: [
            Expanded(
                child: Text('${rk(r.priceFrom)} - ${rk(r.priceTo).substring(3)}',
                    style: ts(13, w: FontWeight.w800, c: AppColors.primaryDark))),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () => openReservation(context, r),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: const StadiumBorder()),
                child: Text('Pesan',
                    style: ts(12, w: FontWeight.w800, c: Colors.white)),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _nearbyTile(BuildContext context, Restaurant r) {
    return GestureDetector(
      onTap: () => openRestaurant(context, r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: box(color: AppColors.surface, r: 22),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            FoodImage(path: r.image, width: 100, height: 118, radius: 16),
            Positioned(
                left: 6,
                bottom: 6,
                child: Pill(
                    text: r.distanceLabel,
                    bg: Colors.black.withAlpha(150),
                    fg: Colors.white,
                    fontSize: 10)),
          ]),
          gapW(12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(r.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark))),
                const Icon(Icons.star_rounded, size: 15, color: AppColors.amber),
                Text('${r.rating}', style: ts(12, w: FontWeight.w800)),
              ]),
              gap(2),
              Text(r.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ts(15, w: FontWeight.w800, h: 1.25)),
              gap(2),
              Text(r.specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ts(12, c: AppColors.muted)),
              gap(8),
              Row(children: [
                Flexible(
                    child: Pill(
                        text: r.tags.isNotEmpty && r.tags.first.contains('Lesehan')
                            ? r.tags.first
                            : 'Sedia ${r.tablesFree} Meja',
                        bg: AppColors.greenSoft,
                        fg: AppColors.green)),
                const Spacer(),
                GestureDetector(
                  onTap: () => openReservation(context, r),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: box(color: AppColors.peach, r: 20),
                    child: Text('Reservasi',
                        style: ts(12, w: FontWeight.w800, c: AppColors.primaryDark)),
                  ),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<RestaurantProvider>();
    final nav = context.read<NavProvider>();

    void searchFor(String q) {
      context.read<RestaurantProvider>()
        ..setQuery(q)
        ..setArea(null);
      nav.go(1);
    }

    return Scaffold(
      body: Column(children: [
        const BrandHeader(title: 'MakanKuy', subtitle: 'Beranda • Ternate'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: AppColors.peach, shape: BoxShape.circle),
                  child: const Icon(Icons.location_on_outlined,
                      color: AppColors.primaryDark),
                ),
                gapW(10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('Ternate, Maluku Utara',
                          style: ts(14, w: FontWeight.w800)),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                    ]),
                    Text('Area Gamalama & Sekitarnya',
                        style: ts(11, c: AppColors.muted)),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: box(color: AppColors.surface, r: 20),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.circle, size: 8, color: AppColors.green),
                    gapW(6),
                    Text('Buka Hari Ini', style: ts(11, w: FontWeight.w700)),
                  ]),
                ),
              ]),
              gap(14),
              GestureDetector(
                onTap: () => nav.go(1),
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.only(left: 16, right: 6),
                  decoration: box(color: AppColors.surface, r: 28),
                  child: Row(children: [
                    const Icon(Icons.search_rounded, color: AppColors.muted),
                    gapW(10),
                    Expanded(
                        child: Text('Cari Gohu Ikan, Ikan Fufu, cafe santai...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ts(14, c: AppColors.muted))),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                          color: AppColors.primaryDark, shape: BoxShape.circle),
                      child: const Icon(Icons.tune_rounded, color: Colors.white),
                    ),
                  ]),
                ),
              ),
              gap(12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  const FilterPill(label: 'Semua', selected: true),
                  gapW(8),
                  FilterPill(
                      label: 'Gohu Ikan',
                      icon: Icons.set_meal_rounded,
                      onTap: () => searchFor('Gohu Ikan')),
                  gapW(8),
                  FilterPill(
                      label: 'Ikan Fufu',
                      icon: Icons.dinner_dining_rounded,
                      onTap: () => searchFor('Fufu')),
                  gapW(8),
                  FilterPill(
                      label: 'Cafe & Kopi',
                      icon: Icons.local_cafe_rounded,
                      onTap: () => searchFor('Cafe')),
                ]),
              ),
              gap(16),
              _promo(context),
              gap(22),
              SectionTitle(
                  title: 'Restoran UMKM Populer',
                  subtitle: 'Pilihan favorit masyarakat Gamalama & sekitarnya',
                  action: 'Semua ›',
                  onAction: () => nav.go(1)),
              gap(12),
              SizedBox(
                height: 275,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      rp.popular.map((r) => _popularCard(context, r)).toList(),
                ),
              ),
              gap(18),
              const SectionTitle(
                  title: 'Rekomendasi Dekat Kamu',
                  subtitle: 'Jarak jalan kaki dari lokasimu sekarang',
                  trailingIcon: Icons.explore_outlined),
              gap(12),
              ...rp.nearby.map((r) => _nearbyTile(context, r)),
              gap(6),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: box(color: AppColors.surface, r: 22),
                child: Row(children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                        color: AppColors.greenSoft,
                        borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.storefront_rounded,
                        color: AppColors.green),
                  ),
                  gapW(12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Punya Warung Makan di Ternate?',
                          style: ts(14, w: FontWeight.w800)),
                      Text('Daftarkan mejamu di MakanKuy gratis',
                          style: ts(12, c: AppColors.muted)),
                    ]),
                  ),
                  ElevatedButton(
                    onPressed: () => toast(context, 'Pendaftaran mitra segera hadir'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.ink,
                        shape: const StadiumBorder()),
                    child: Text('Gabung\nMitra',
                        textAlign: TextAlign.center,
                        style: ts(12, w: FontWeight.w800)),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}