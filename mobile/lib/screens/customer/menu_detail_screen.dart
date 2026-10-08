import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/restaurant.dart';
import '../../providers/reservation_provider.dart';

class MenuDetailScreen extends StatefulWidget {
  final MenuItem menu;
  final Restaurant restaurant;
  const MenuDetailScreen(
      {super.key, required this.menu, required this.restaurant});
  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _Opt {
  final String title, sub;
  final int extra;
  final String? badge;
  final IconData? icon;
  const _Opt(this.title, this.sub, {this.extra = 0, this.badge, this.icon});
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  static const _spice = [
    _Opt('Sedang', 'Rica rawit 3 biji • Pedas ramah', icon: Icons.sentiment_satisfied_alt_rounded),
    _Opt('Pedas Mantap', 'Rica rawit 7 biji • Racikan autentik Ternate', badge: 'Rekomendasi', icon: Icons.local_fire_department_rounded),
    _Opt('Super Pedas Khas Gamalama', 'Rica rawit 12 biji • Sangat pedas & membakar', icon: Icons.whatshot_rounded),
  ];
  static const _fish = [
    _Opt('Ikan Cakalang Segar', 'Daging padat gurih khas laut Maluku'),
    _Opt('Ikan Tuna Sirip Kuning (Yellowfin)', 'Sangat lembut, berlemak & manis segar', extra: 5000),
  ];
  static const _addons = [
    _Opt('Ekstra Kacang Kenari Panggang', 'Lebih gurih, renyah melimpah', extra: 5000),
    _Opt('Pisang Goreng Mulut Bebek', 'Teman makan gohu paling nikmat', extra: 10000),
    _Opt('Singkong / Kasbi Rebus Hangat', 'Empuk pulen pelengkap sarapan pantai', extra: 8000),
  ];

  int _s = 1;
  int _f = 0;
  final Set<int> _a = {};
  int _qty = 1;
  final _note = TextEditingController();

  int get _unit =>
      widget.menu.price +
      _fish[_f].extra +
      _a.fold(0, (s, i) => s + _addons[i].extra);
  int get _total => _unit * _qty;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Widget _head(IconData i, String t, String tag, Color tagBg, Color tagFg) =>
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Row(children: [
          Icon(i, size: 20, color: AppColors.primaryDark),
          gapW(8),
          Expanded(child: Text(t, style: ts(15, w: FontWeight.w800))),
          Pill(text: tag, bg: tagBg, fg: tagFg, fontSize: 10),
        ]),
      );

  Widget _tile(_Opt o, bool selected, VoidCallback onTap,
      {bool check = false, bool showExtra = true}) {
    final icon = check
        ? (selected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded)
        : (selected ? Icons.radio_button_checked : Icons.radio_button_unchecked);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? AppColors.primaryDark : Colors.transparent,
              width: 1.5),
        ),
        child: Row(children: [
          Icon(icon, color: selected ? AppColors.primaryDark : AppColors.muted),
          gapW(10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: Text(o.title, style: ts(14, w: FontWeight.w800))),
                if (o.badge != null) ...[
                  gapW(6),
                  Pill(text: o.badge!, bg: AppColors.amberSoft, fg: const Color(0xFF6B4400), fontSize: 9),
                ],
              ]),
              Text(o.sub, style: ts(11, c: AppColors.muted)),
            ]),
          ),
          if (o.icon != null) Icon(o.icon, color: AppColors.primary),
          if (showExtra && o.extra > 0)
            Text('+${rupiah(o.extra)}',
                style: ts(12, w: FontWeight.w800, c: AppColors.primaryDark)),
          if (showExtra && o.extra == 0 && o.icon == null && !check)
            Text('Standar', style: ts(12, c: AppColors.muted)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.menu;
    return Scaffold(
      body: Column(children: [
        DetailTopBar(
            title: 'Detail Restoran',
            onShare: () => Share.share('${m.name} di ${widget.restaurant.name} - MakanKuy')),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            SizedBox(
              height: 270,
              child: Stack(fit: StackFit.expand, children: [
                FoodImage(path: m.image, radius: 0),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xAA000000)]),
                  ),
                ),
                const Positioned(
                    left: 14,
                    top: 14,
                    child: Pill(
                        text: 'Paling Favorit di Ternate',
                        bg: AppColors.primary,
                        fg: Colors.white,
                        icon: Icons.local_fire_department)),
                const Positioned(
                    right: 14,
                    top: 14,
                    child: Pill(
                        text: 'Tangkapan Hari Ini',
                        bg: Colors.white,
                        fg: AppColors.green,
                        icon: Icons.eco_rounded)),
                Positioned(
                    left: 14,
                    bottom: 14,
                    child: Pill(
                        text: '${m.rating} (${m.reviews} ulasan)',
                        bg: Colors.black.withAlpha(120),
                        fg: Colors.white,
                        icon: Icons.star_rounded,
                        fontSize: 12)),
                const Positioned(
                    right: 14,
                    bottom: 14,
                    child: Pill(
                        text: 'Porsi 1–2 Orang',
                        bg: Colors.transparent,
                        fg: Colors.white,
                        icon: Icons.restaurant,
                        fontSize: 12)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: Text(m.name,
                          style: ts(24, w: FontWeight.w800, h: 1.2))),
                  gapW(8),
                  Text(rupiah(m.price),
                      style: ts(20, w: FontWeight.w800, c: AppColors.primaryDark)),
                ]),
                gap(4),
                Text('Sashimi Tradisional Khas Maluku Utara',
                    style: ts(13, w: FontWeight.w600, c: AppColors.muted)),
                gap(14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: box(color: AppColors.surface, r: 18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.menu_book_rounded, size: 18, color: AppColors.primaryDark),
                      gapW(6),
                      Text('Cerita & Tradisi Kuliner',
                          style: ts(13, w: FontWeight.w800, c: AppColors.primaryDark)),
                    ]),
                    gap(8),
                    Text(
                        'Gohu Ikan tersohor sebagai mahakarya kuliner Ternate yang dijuluki "Sashimi Moluccas". Dibuat langsung dari potongan cakalang segar yang baru diturunkan dari perahu nelayan, dimatangkan alami menggunakan asam segar perasan jeruk kasturi tanpa proses pemasangan api. Taburan kacang kenari panggang khas Pulau Ternate dan aroma daun kemangi memberikan keseimbangan gurih, renyah, dan pedas yang meledak di lidah.',
                        style: ts(12, c: AppColors.muted, h: 1.65)),
                  ]),
                ),
                _head(Icons.local_fire_department_outlined, 'Tingkat Kepedasan (Rica)', 'Wajib Pilih', AppColors.peach, AppColors.primaryDark),
                for (var i = 0; i < _spice.length; i++)
                  _tile(_spice[i], _s == i, () => setState(() => _s = i)),
                _head(Icons.set_meal_outlined, 'Pilihan Ikan Segar', 'Wajib Pilih', AppColors.peach, AppColors.primaryDark),
                for (var i = 0; i < _fish.length; i++)
                  _tile(_fish[i], _f == i, () => setState(() => _f = i)),
                _head(Icons.add_circle_outline_rounded, 'Tambahan Pelengkap', 'Opsional', AppColors.surface, AppColors.muted),
                for (var i = 0; i < _addons.length; i++)
                  _tile(_addons[i], _a.contains(i),
                      () => setState(() => _a.contains(i) ? _a.remove(i) : _a.add(i)),
                      check: true),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(children: [
                    const Icon(Icons.edit_note_rounded, size: 22, color: AppColors.primaryDark),
                    gapW(8),
                    Expanded(child: Text('Catatan Khusus Meja', style: ts(15, w: FontWeight.w800))),
                    Text('${_note.text.length}/150', style: ts(11, c: AppColors.muted)),
                  ]),
                ),
                TextField(
                  controller: _note,
                  maxLines: 3,
                  maxLength: 150,
                  onChanged: (_) => setState(() {}),
                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                  decoration: const InputDecoration(
                      hintText: 'Contoh: Daun kemangi dibanyakin, jeruk kasturi dipisah...'),
                ),
                gap(16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: box(color: AppColors.surface, r: 20),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('TOTAL PESANAN', style: ts(10, w: FontWeight.w700, c: AppColors.muted)),
                        Text(rupiah(_total),
                            style: ts(20, w: FontWeight.w800, c: AppColors.primaryDark)),
                      ]),
                    ),
                    Container(
                      decoration: box(color: Colors.white, r: 30),
                      child: Row(children: [
                        IconButton(
                            onPressed: () => setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                            icon: const Icon(Icons.remove_rounded)),
                        Text('$_qty', style: ts(16, w: FontWeight.w800)),
                        Container(
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () => setState(() => _qty++),
                              icon: const Icon(Icons.add_rounded, color: Colors.white)),
                        ),
                      ]),
                    ),
                  ]),
                ),
                gap(10),
              ]),
            ),
          ]),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ReservationProvider>().addPreorder(m.name, _unit, _qty);
                  toast(context, '$_qty× ${m.name} ditambahkan ke reservasi');
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder()),
                child: Row(children: [
                  const Icon(Icons.room_service_outlined, size: 20),
                  gapW(10),
                  Expanded(
                      child: Text('Tambahkan ke Reservasi Meja',
                          style: ts(14, w: FontWeight.w800, c: Colors.white))),
                  Text(rupiah(_total),
                      style: ts(14, w: FontWeight.w800, c: Colors.white)),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}