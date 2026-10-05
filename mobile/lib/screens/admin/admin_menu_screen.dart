import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/menu_item.dart';
import '../../providers/menu_provider.dart';
import 'admin_shell.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});
  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  static const _cats = ['Menu Khas Ternate', 'Ikan & Seafood', 'Menu Tradisional', 'Minuman Tradisional', 'Camilan'];
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _form(BuildContext context, {MenuItem? item}) {
    final mp = context.read<MenuProvider>();
    final name = TextEditingController(text: item?.name);
    final price = TextEditingController(text: item?.price.toString());
    final desc = TextEditingController(text: item?.description);
    String cat = item?.category ?? _cats.first;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(item == null ? 'Tambah Menu Baru' : 'Ubah Menu', style: ts(18, w: FontWeight.w800))),
                if (item != null)
                  IconButton(
                    onPressed: () {
                      mp.remove(item);
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red),
                  ),
              ]),
              gap(12),
              TextField(controller: name, decoration: const InputDecoration(hintText: 'Nama menu')),
              gap(10),
              TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Harga (contoh: 35000)')),
              gap(10),
              TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(hintText: 'Deskripsi singkat')),
              gap(12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final c in _cats)
                  FilterPill(label: c, selected: cat == c, selBg: AppColors.primary, onTap: () => setS(() => cat = c)),
              ]),
              gap(16),
              PrimaryButton(
                label: 'Simpan Menu',
                onPressed: () {
                  final n = name.text.trim();
                  final pr = int.tryParse(price.text.trim()) ?? 0;
                  if (n.isEmpty || pr <= 0) {
                    toast(ctx, 'Nama dan harga wajib diisi dengan benar');
                    return;
                  }
                  if (item == null) {
                    mp.add(MenuItem(
                        id: 'm${DateTime.now().millisecondsSinceEpoch}',
                        restaurantId: 'r1',
                        name: n,
                        description: desc.text.trim(),
                        price: pr,
                        category: cat));
                  } else {
                    mp.update(item, n, pr, cat, desc.text.trim());
                  }
                  Navigator.pop(ctx);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _count(String v, String l, Color bg, Color fg) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: box(color: bg, r: 16),
          child: Column(children: [
            Text(v, style: ts(20, w: FontWeight.w800, c: fg)),
            Text(l, style: ts(11, w: FontWeight.w700, c: fg)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MenuProvider>();
    final list = mp.adminList;
    final chips = ['Semua', 'Menu Khas Ternate', 'Ikan & Seafood', 'Minuman', 'Camilan'];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _form(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('Tambah Menu Baru', style: ts(14, w: FontWeight.w800, c: Colors.white)),
        shape: const StadiumBorder(),
      ),
      body: Column(children: [
        const AdminHeader(),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 90), children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(color: AppColors.surface, r: 22),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.restaurant_menu_rounded, color: AppColors.primaryDark),
                  gapW(8),
                  Text('Katalog Menu Dapur', style: ts(15, w: FontWeight.w800)),
                  const Spacer(),
                  const Pill(text: 'Live WIT', bg: AppColors.greenSoft, fg: AppColors.green),
                ]),
                gap(10),
                Row(children: [
                  _count('${mp.total}', 'Total Menu', Colors.white, AppColors.ink),
                  gapW(8),
                  _count('${mp.availableCount}', 'Tersedia', const Color(0xFFDCEFEF), AppColors.green),
                  gapW(8),
                  _count('${mp.soldOut}', 'Habis Stok', AppColors.redSoft, AppColors.red),
                ]),
                gap(10),
                Row(children: [
                  const Icon(Icons.directions_boat_outlined, size: 16, color: AppColors.green),
                  gapW(6),
                  Expanded(
                      child: Text('Pasokan nelayan Pelabuhan Bastiong hari ini lancar',
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(11, c: AppColors.muted))),
                  Text('Sinkronkan', style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark)),
                ]),
              ]),
            ),
            gap(12),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: box(color: AppColors.surface, r: 26),
              child: Row(children: [
                const Icon(Icons.search_rounded, color: AppColors.muted),
                gapW(8),
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: mp.setAdminQuery,
                    decoration: const InputDecoration(
                        hintText: 'Cari menu masakan Ternate...',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                if (mp.adminQuery.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        _search.clear();
                        mp.setAdminQuery('');
                      },
                      child: const Icon(Icons.close_rounded, color: AppColors.muted)),
              ]),
            ),
            gap(10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final c in chips) ...[
                  FilterPill(
                      label: c == 'Semua' ? 'Semua (${mp.total})' : c,
                      selected: mp.adminCategory == c,
                      selBg: AppColors.primary,
                      onTap: () => mp.setAdminCategory(c)),
                  gapW(8),
                ],
              ]),
            ),
            gap(12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.amberSoft, r: 18),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle),
                  child: const Icon(Icons.inventory_2_outlined, size: 20),
                ),
                gapW(10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Cek Cepat Stok Segar', style: ts(13, w: FontWeight.w800)),
                    Text('Perbarui ketersediaan hasil laut nelayan', maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(11, c: AppColors.muted)),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () => toast(context, 'Atur massal segera hadir'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryDark,
                      elevation: 0,
                      shape: const StadiumBorder()),
                  child: Text('Atur Massal', style: ts(12, w: FontWeight.w800, c: AppColors.primaryDark)),
                ),
              ]),
            ),
            gap(12),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(child: Text('Menu tidak ditemukan', style: ts(13, c: AppColors.muted))),
              ),
            ...list.map((m) {
              final off = !m.available;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: box(color: AppColors.surface, r: 22),
                child: Row(children: [
                  Stack(children: [
                    FoodImage(path: m.image, width: 92, height: 96, radius: 16),
                    if (m.badge != null)
                      Positioned(
                        left: 4,
                        top: 4,
                        child: Pill(
                            text: m.badge!,
                            bg: m.badge == 'HABIS' ? AppColors.red : (m.badge == 'HANGAT' ? AppColors.green : AppColors.primary),
                            fg: Colors.white,
                            fontSize: 9),
                      ),
                  ]),
                  gapW(12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m.name,
                          style: ts(15, w: FontWeight.w800, c: off ? AppColors.muted : AppColors.ink, h: 1.2)),
                      Text('${m.category}${m.tagline.isEmpty ? '' : ' • ${m.tagline}'}',
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(11, c: AppColors.muted)),
                      Text(rupiah(m.price),
                          style: ts(16, w: FontWeight.w800, c: off ? AppColors.muted : AppColors.primaryDark)),
                      Row(children: [
                        Switch(
                          value: m.available,
                          activeColor: Colors.white,
                          activeTrackColor: AppColors.green,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (_) => mp.toggle(m),
                        ),
                        Expanded(
                          child: Text(m.available ? 'Tersedia' : 'Habis Hari Ini',
                              style: ts(11, w: FontWeight.w800, c: m.available ? AppColors.green : AppColors.red)),
                        ),
                        GestureDetector(
                          onTap: () => _form(context, item: m),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: box(color: Colors.white, r: 16),
                            child: Row(children: [
                              const Icon(Icons.edit_outlined, size: 13, color: AppColors.primaryDark),
                              gapW(4),
                              Text('Ubah', style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark)),
                            ]),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                ]),
              );
            }),
          ]),
        ),
      ]),
    );
  }
}