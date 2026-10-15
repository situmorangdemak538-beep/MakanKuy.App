import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/restaurant.dart';
import '../../providers/restaurant_provider.dart';
import 'reservation_form_screen.dart';
import 'restaurant_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _card(BuildContext context, Restaurant r) {
    return GestureDetector(
      onTap: () => openRestaurant(context, r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(8),
        decoration: box(color: AppColors.surface, r: 26),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            FoodImage(
                path: r.image,
                height: 150,
                width: double.infinity,
                radius: 20),
            if (r.badge != null)
              Positioned(
                  left: 8,
                  top: 8,
                  child: Pill(
                      text: r.badge!,
                      bg: r.badge!.contains('Meja')
                          ? AppColors.green
                          : Colors.white.withAlpha(230),
                      fg: r.badge!.contains('Meja')
                          ? Colors.white
                          : AppColors.primaryDark,
                      icon: r.badge!.contains('Meja')
                          ? Icons.event_seat_rounded
                          : Icons.local_offer_outlined)),
            Positioned(
                right: 8,
                top: 8,
                child: Pill(
                    text: '${r.rating} (${r.reviews})',
                    bg: Colors.black.withAlpha(140),
                    fg: Colors.white,
                    icon: Icons.star_rounded)),
            if (r.highlight != null)
              Positioned(
                  right: 8,
                  bottom: 8,
                  child: Pill(
                      text: r.highlight!,
                      bg: Colors.white.withAlpha(230),
                      fg: AppColors.primaryDark,
                      icon: Icons.local_fire_department)),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Text(r.name,
                        style: ts(16, w: FontWeight.w800, h: 1.25))),
                gapW(8),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(rb(r.priceFrom),
                      style: ts(16, w: FontWeight.w800, c: AppColors.primaryDark)),
                  Text(r.priceNote, style: ts(11, c: AppColors.muted)),
                ]),
              ]),
              gap(4),
              Row(children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.primaryDark),
                gapW(4),
                Expanded(
                    child: Text('${r.address.split(',').first}, ${r.area} • ${r.distanceKm} km',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ts(12, c: AppColors.muted))),
              ]),
              gap(8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: box(color: Colors.white, r: 10),
                child: Text.rich(
                  TextSpan(
                      text: '${r.specialtyLabel}: ',
                      style: ts(12, w: FontWeight.w800, c: AppColors.primaryDark),
                      children: [
                        TextSpan(
                            text: r.specialty,
                            style: ts(12, c: AppColors.muted))
                      ]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              gap(10),
              Row(children: [
                Expanded(
                  child: Wrap(spacing: 6, runSpacing: 6, children: [
                    for (var i = 0; i < r.tags.length; i++)
                      Pill(
                          text: r.tags[i],
                          bg: i == 0 ? AppColors.greenSoft : AppColors.amberSoft,
                          fg: i == 0 ? AppColors.green : const Color(0xFF6B4400),
                          fontSize: 10),
                  ]),
                ),
                gapW(8),
                SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: () => openReservation(context, r),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: Text('Reservasi',
                        style: ts(12, w: FontWeight.w800, c: Colors.white)),
                    iconAlignment: IconAlignment.end,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder()),
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
    if (_ctrl.text != rp.query) {
      _ctrl.value = TextEditingValue(
          text: rp.query,
          selection: TextSelection.collapsed(offset: rp.query.length));
    }
    final results = rp.results;

    return Scaffold(
      body: Column(children: [
        const BrandHeader(title: 'MakanKuy', subtitle: 'Cari • Ternate'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Container(
            height: 54,
            padding: const EdgeInsets.only(left: 6, right: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(18),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(children: [
              const Icon(Icons.search_rounded, color: AppColors.muted),
              gapW(8),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  onChanged: rp.setQuery,
                  decoration: const InputDecoration(
                      hintText: 'Cari Gohu Ikan, Ikan Fufu...',
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                  style: ts(15, w: FontWeight.w700),
                ),
              ),
              if (rp.query.isNotEmpty)
                IconButton(
                    onPressed: () => rp.setQuery(''),
                    icon: const Icon(Icons.cancel_rounded, color: AppColors.muted)),
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.tune_rounded, color: Colors.white),
              ),
            ]),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            FilterPill(
                label: 'Semua Wilayah',
                selected: rp.area == null,
                onTap: () => rp.setArea(null)),
            gapW(8),
            FilterPill(
                label: 'Ternate Tengah',
                icon: Icons.location_on,
                selected: rp.area == 'Ternate Tengah',
                onTap: () => rp.setArea('Ternate Tengah')),
            gapW(8),
            FilterPill(
                label: 'Ternate Selatan',
                icon: Icons.location_on,
                selected: rp.area == 'Ternate Selatan',
                onTap: () => rp.setArea('Ternate Selatan')),
          ]),
        ),
        gap(8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            FilterPill(
                label: 'Rating 4.5+',
                icon: Icons.star_rounded,
                selected: rp.rating45,
                selBg: AppColors.amber,
                selFg: AppColors.ink,
                onTap: rp.toggleRating),
            gapW(8),
            FilterPill(
                label: 'Meja Kosong Sekarang',
                icon: Icons.event_seat_outlined,
                selected: rp.tableOnly,
                selBg: AppColors.amber,
                selFg: AppColors.ink,
                onTap: rp.toggleTable),
            gapW(8),
            FilterPill(
                label: '< Rp 50k',
                icon: Icons.payments_outlined,
                selected: rp.under50,
                selBg: AppColors.amber,
                selFg: AppColors.ink,
                onTap: rp.toggleUnder50),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(children: [
            Expanded(
              child: Text.rich(TextSpan(
                  text: 'Menampilkan ',
                  style: ts(13, c: AppColors.muted),
                  children: [
                    TextSpan(
                        text: '${results.length} Resto UMKM',
                        style: ts(13, w: FontWeight.w800, c: AppColors.primaryDark)),
                    TextSpan(text: ' di ${rp.area ?? 'Ternate'}'),
                  ])),
            ),
            PopupMenuButton<String>(
              onSelected: rp.setSort,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'Terdekat', child: Text('Terdekat')),
                PopupMenuItem(value: 'Rating', child: Text('Rating tertinggi')),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Text('Urutkan', style: ts(12, w: FontWeight.w700)),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                ]),
              ),
            ),
          ]),
        ),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.search_off_rounded,
                        size: 48, color: AppColors.muted),
                    gap(8),
                    Text('Restoran tidak ditemukan',
                        style: ts(15, w: FontWeight.w800)),
                    Text('Coba ubah kata kunci atau filter',
                        style: ts(12, c: AppColors.muted)),
                  ]),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    ...results.map((r) => _card(context, r)),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: box(color: AppColors.surface, r: 20),
                      child: Row(children: [
                        const Icon(Icons.explore_outlined,
                            color: AppColors.primaryDark),
                        gapW(12),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Belum menemukan selera?',
                                    style: ts(14, w: FontWeight.w800)),
                                Text('Coba perluas ke seluruh pulau Ternate',
                                    style: ts(12, c: AppColors.muted)),
                              ]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            rp.setQuery('');
                            rp.setArea(null);
                            if (rp.rating45) rp.toggleRating();
                            if (rp.tableOnly) rp.toggleTable();
                            if (rp.under50) rp.toggleUnder50();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.ink,
                              shape: const StadiumBorder()),
                          child: Text('Reset Filter',
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