import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/admin_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/restaurant.dart';
import '../../providers/restaurant_provider.dart';
import '../partner/register_restaurant_screen.dart';
import 'administrator_shell.dart';
 
/// Kartu pendaftaran warung baru + tombol Setujui / Tolak (dipakai juga di dashboard).
class PendingRestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const PendingRestaurantCard({super.key, required this.restaurant});
 
  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    final rp = context.read<RestaurantProvider>();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: box(color: Colors.white, r: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AdminColors.indigoSoft, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.storefront_rounded, color: AdminColors.indigo),
          ),
          gapW(12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.name, style: ts(14, w: FontWeight.w800)),
              Text('Pemilik: ${r.ownerName.isEmpty ? '-' : r.ownerName}', style: ts(11, c: AppColors.muted)),
            ]),
          ),
          const Pill(text: 'Menunggu', bg: AppColors.amberSoft, fg: Color(0xFF6B4400), fontSize: 10),
        ]),
        gap(10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          Pill(text: '${r.totalTables} meja', icon: Icons.table_restaurant_rounded),
          Pill(text: '${r.seatsPerTable} kursi/meja'),
          Pill(text: r.hours, icon: Icons.schedule_rounded),
          Pill(text: r.area, icon: Icons.location_on_outlined),
          Pill(text: 'Mulai ${rb(r.priceFrom)}'),
        ]),
        gap(8),
        Text(r.address, style: ts(12, c: AppColors.muted)),
        gap(12),
        Row(children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                rp.approve(r); // Backend: PUT /api/restaurants/{id}/approve
                toast(context, '${r.name} disetujui & aktif');
              },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text('Setujui', style: ts(13, w: FontWeight.w800, c: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.mint,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
          ),
          gapW(10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                rp.reject(r); // Backend: PUT /api/restaurants/{id}/reject
                toast(context, '${r.name} ditolak');
              },
              icon: const Icon(Icons.close_rounded, size: 18),
              label: Text('Tolak', style: ts(13, w: FontWeight.w800, c: AppColors.red)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redSoft,
                  foregroundColor: AppColors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
          ),
        ]),
      ]),
    );
  }
}
 
class AdministratorRestaurantsScreen extends StatefulWidget {
  const AdministratorRestaurantsScreen({super.key});
  @override
  State<AdministratorRestaurantsScreen> createState() => _AdministratorRestaurantsScreenState();
}
 
class _AdministratorRestaurantsScreenState extends State<AdministratorRestaurantsScreen> {
  int _tab = 0;
 
  @override
  Widget build(BuildContext context) {
    final rp = context.watch<RestaurantProvider>();
    final labels = ['Menunggu (${rp.pending.length})', 'Aktif (${rp.all.length})'];
    return Scaffold(
      backgroundColor: AdminColors.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openRegisterRestaurant(context),
        backgroundColor: AdminColors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business_rounded),
        label: Text('Tambah Warung', style: ts(14, w: FontWeight.w800, c: Colors.white)),
      ),
      body: Column(children: [
        const AdministratorHeader(
            title: 'Persetujuan Warung', subtitle: 'Setujui atau tolak pendaftaran mitra baru'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(children: [
            for (var i = 0; i < 2; i++) ...[
              FilterPill(
                  label: labels[i],
                  selected: _tab == i,
                  selBg: AdminColors.indigo,
                  onTap: () => setState(() => _tab = i)),
              gapW(8),
            ],
          ]),
        ),
        Expanded(
          child: _tab == 0
              ? (rp.pending.isEmpty
                  ? Center(child: Text('Tidak ada pendaftaran menunggu', style: ts(13, c: AppColors.muted)))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                      children: rp.pending.map((r) => PendingRestaurantCard(restaurant: r)).toList()))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                  children: rp.all
                      .map((r) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: box(color: Colors.white, r: 16),
                            child: Row(children: [
                              FoodImage(path: r.image, width: 56, height: 56, radius: 12),
                              gapW(12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(14, w: FontWeight.w800)),
                                  Text('${r.area} • ${r.totalTables} meja • ${r.hours}', style: ts(11, c: AppColors.muted)),
                                ]),
                              ),
                              Pill(text: '★ ${r.rating}', bg: AppColors.amberSoft, fg: const Color(0xFF6B4400)),
                            ]),
                          ))
                      .toList()),
        ),
      ]),
    );
  }
}