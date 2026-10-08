import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/restaurant.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nav_provider.dart';
import '../../providers/reservation_provider.dart';

void openReservation(BuildContext context, Restaurant r) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReservationFormScreen(restaurant: r)));
}

class _Slot {
  final String time;
  final String sub;
  final bool full;
  const _Slot(this.time, this.sub, {this.full = false});
}

class _Seat {
  final String name, desc, tag, left, image;
  const _Seat(this.name, this.desc, this.tag, this.left, this.image);
}

class ReservationFormScreen extends StatelessWidget {
  final Restaurant restaurant;
  const ReservationFormScreen({super.key, required this.restaurant});

  static const _lunch = [
    _Slot('11:30', ''),
    _Slot('12:00', ''),
    _Slot('13:00', 'PENUH', full: true),
  ];
  static const _dinner = [
    _Slot('18:00', 'Sunset Gamalama'),
    _Slot('19:00', 'Favorit Pelanggan'),
    _Slot('20:00', 'Tersedia'),
    _Slot('20:30', 'Tersedia'),
  ];
  static const _seats = [
    _Seat('Lesehan View Laut & Sunset', 'Duduk santai di atas geladak kayu dengan semilir angin laut dan panorama Pulau Tidore.', 'Paling Diminati', 'Sisa 2 Meja', 'assets/images/seat_lesehan.jpg'),
    _Seat('Meja Reguler Indoor AC', 'Ruang berpendingin udara yang sejuk dan tenang, ramah keluarga & lansia.', 'Bebas Asap Rokok', 'Sisa 5 Meja', 'assets/images/seat_indoor.jpg'),
    _Seat('Outdoor Gazebo Kenari', 'Bale-bale privat di bawah rindang pohon kenari tua, suasana asri dan sejuk.', 'Area Smoking', 'Sisa 1 Gazebo', 'assets/images/seat_gazebo.jpg'),
  ];

  Widget _step(int n, String title, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 10),
        child: Row(children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
            child: Text('$n', style: ts(12, w: FontWeight.w800, c: Colors.white)),
          ),
          gapW(10),
          Expanded(child: Text(title, style: ts(16, w: FontWeight.w800))),
          if (trailing != null) trailing,
        ]),
      );

  Widget _slotGrid(ReservationProvider p, List<_Slot> slots, int cols) {
    return GridView.count(
      crossAxisCount: cols,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: cols == 3 ? 1.9 : 2.5,
      children: slots.map((s) {
        final sel = p.time == s.time;
        return GestureDetector(
          onTap: s.full ? null : () => p.setTime(s.time),
          child: Container(
            decoration: box(color: sel ? AppColors.primary : AppColors.surface, r: 14),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${s.time} WIT',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: sel
                          ? Colors.white
                          : (s.full ? AppColors.muted : AppColors.ink),
                      decoration: s.full ? TextDecoration.lineThrough : null)),
              if (s.sub.isNotEmpty)
                Text(s.sub,
                    style: ts(10,
                        w: FontWeight.w700,
                        c: s.full
                            ? AppColors.red
                            : (sel ? Colors.white : AppColors.muted))),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _row(IconData i, String label, String value, {Color? vc}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(i, size: 18, color: AppColors.muted),
          gapW(8),
          SizedBox(
              width: 82,
              child: Text(label, style: ts(12, c: AppColors.muted))),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: ts(13, w: FontWeight.w800, c: vc))),
        ]),
      );

  Future<void> _submit(BuildContext context) async {
    final p = context.read<ReservationProvider>();
    final auth = context.read<AuthProvider>();
    final nav = context.read<NavProvider>();
    if (p.time == null) {
      toast(context, 'Pilih jam kedatangan terlebih dahulu');
      return;
    }
    final res = p.submit(restaurant,
        name: auth.user?.name ?? 'Pelanggan',
        phone: auth.user?.phone ?? '');
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.green),
          gapW(8),
          const Expanded(child: Text('Reservasi Dikirim')),
        ]),
        content: Text(
            'Kode ${res.code}\n${restaurant.name}\n${dateLabel(res.date)} • ${res.time} WIT • ${res.guests} orang\n\nStatus: Pending, menunggu persetujuan resto.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Lihat Riwayat',
                  style: ts(14, w: FontWeight.w800, c: AppColors.primaryDark))),
        ],
      ),
    );
    if (!context.mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
    nav.go(2);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReservationProvider>();
    final auth = context.watch<AuthProvider>();
    final r = restaurant;
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.add(Duration(days: i)));

    return Scaffold(
      body: Column(children: [
        DetailTopBar(
          title: 'Formulir Reservasi',
          onShare: () => Share.share('Reservasi di ${r.name} via MakanKuy'),
        ),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 16), children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.surface, r: 20),
              child: Row(children: [
                Stack(children: [
                  FoodImage(path: r.image, width: 72, height: 72, radius: 14),
                  const Positioned(
                      left: 4,
                      bottom: 4,
                      child: Pill(text: 'Buka', bg: AppColors.green, fg: Colors.white, fontSize: 9)),
                ]),
                gapW(12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('KULINER KHAS GAMALAMA',
                        style: ts(9, w: FontWeight.w800, c: AppColors.primaryDark)),
                    Text(r.name, style: ts(15, w: FontWeight.w800)),
                    Text(r.address.split(',').first,
                        style: ts(11, c: AppColors.muted)),
                    gap(4),
                    const Pill(
                        text: 'AC & Lesehan Tepi Laut',
                        bg: AppColors.greenSoft,
                        fg: AppColors.green,
                        fontSize: 9),
                  ]),
                ),
              ]),
            ),
            _step(1, 'Pilih Tanggal',
                trailing: Row(children: [
                  const Icon(Icons.circle, size: 7, color: AppColors.green),
                  gapW(4),
                  Text('${monthLong(p.date)} ${p.date.year}',
                      style: ts(11, w: FontWeight.w700, c: AppColors.green)),
                ])),
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                separatorBuilder: (_, __) => gapW(8),
                itemBuilder: (_, i) {
                  final d = days[i];
                  final sel = isSameDay(d, p.date);
                  final c = sel ? Colors.white : AppColors.ink;
                  return GestureDetector(
                    onTap: () => p.setDate(d),
                    child: Container(
                      width: 66,
                      decoration: box(color: sel ? AppColors.primary : AppColors.surface, r: 18),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(i == 0 ? 'Hari Ini' : (i == 1 ? 'Besok' : dayShort(d)),
                            style: ts(11, c: sel ? Colors.white : AppColors.muted)),
                        Text('${d.day}', style: ts(24, w: FontWeight.w800, c: c)),
                        Text(i < 2 ? dayShort(d) : monthShort(d),
                            style: ts(11, c: sel ? Colors.white : AppColors.muted)),
                      ]),
                    ),
                  );
                },
              ),
            ),
            _step(2, 'Pilih Jam Kedatangan',
                trailing: Text('Waktu Indonesia Timur (WIT)',
                    style: ts(10, c: AppColors.muted))),
            Text('Makan Siang (Lunch)', style: ts(12, w: FontWeight.w700, c: AppColors.muted)),
            gap(8),
            _slotGrid(p, _lunch, 3),
            gap(12),
            Text('Makan Malam (Dinner)', style: ts(12, w: FontWeight.w700, c: AppColors.muted)),
            gap(8),
            _slotGrid(p, _dinner, 2),
            _step(3, 'Jumlah Kursi'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.surface, r: 18),
              child: Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                      color: AppColors.amberSoft, shape: BoxShape.circle),
                  child: const Icon(Icons.groups_rounded, color: AppColors.primaryDark),
                ),
                gapW(12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Jumlah Kursi', style: ts(14, w: FontWeight.w800)),
                    Text('Cocok untuk meja lesehan santai', style: ts(11, c: AppColors.muted)),
                  ]),
                ),
                IconButton(
                    onPressed: () => p.setGuests(p.guests - 1),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    icon: const Icon(Icons.remove_rounded)),
                SizedBox(
                    width: 28,
                    child: Text('${p.guests}',
                        textAlign: TextAlign.center,
                        style: ts(18, w: FontWeight.w800, c: AppColors.primaryDark))),
                IconButton(
                    onPressed: () => p.setGuests(p.guests + 1),
                    style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                    icon: const Icon(Icons.add_rounded, color: Colors.white)),
              ]),
            ),
            _step(4, 'Pilih Posisi Meja',
                trailing: Text('Suasana Khas', style: ts(11, w: FontWeight.w700, c: AppColors.green))),
            ..._seats.map((s) {
              final sel = p.seat == s.name;
              return GestureDetector(
                onTap: () => p.setSeat(s.name),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: sel ? AppColors.primary : Colors.transparent, width: 1.5),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FoodImage(path: s.image, width: 70, height: 84, radius: 12),
                    gapW(12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(s.name, style: ts(14, w: FontWeight.w800))),
                          Icon(sel ? Icons.check_circle_rounded : Icons.circle_outlined,
                              color: sel ? AppColors.primary : AppColors.border),
                        ]),
                        Text(s.desc,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: ts(11, c: AppColors.muted, h: 1.35)),
                        gap(6),
                        Row(children: [
                          Pill(text: s.tag, bg: AppColors.greenSoft, fg: AppColors.green, fontSize: 9),
                          gapW(8),
                          Text(s.left, style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark)),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              );
            }),
            _step(5, 'Permintaan Khusus',
                trailing: Text('Opsional', style: ts(11, c: AppColors.muted))),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: box(color: Colors.white, r: 18, border: AppColors.border),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Catatan untuk Pelayan ${r.name.split(' ').take(3).join(' ')}:',
                    style: ts(12, w: FontWeight.w700)),
                gap(8),
                TextField(
                  maxLines: 3,
                  onChanged: p.setNote,
                  decoration: const InputDecoration(
                      hintText: 'Tulis catatan khusus untuk resto (contoh: minta baby chair, meja dekat colokan, perayaan ulang tahun, tingkat kepedasan rica)...'),
                ),
                gap(8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final t in ['Kursi Balita', 'Meja Stopkontak', 'Ulang Tahun / Lilin'])
                    FilterPill(label: '+ $t', onTap: () => p.appendNote(t)),
                ]),
              ]),
            ),
            gap(16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(color: AppColors.surface, r: 22),
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.peach, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryDark),
                  ),
                  gapW(10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Ringkasan Reservasi', style: ts(14, w: FontWeight.w800)),
                      Text('Konfirmasi Instan tanpa Antre', style: ts(11, c: AppColors.muted)),
                    ]),
                  ),
                  const Pill(text: 'Garansi Meja', bg: AppColors.greenSoft, fg: AppColors.green),
                ]),
                gap(8),
                _row(Icons.calendar_month_outlined, 'Tanggal & Waktu',
                    '${relDay(p.date)}, ${p.date.day} ${monthShort(p.date)} ${p.date.year} • ${p.time ?? '-'} WIT'),
                _row(Icons.event_seat_outlined, 'Tamu & Posisi Meja', '${p.guests} Orang (${p.seat})'),
                _row(Icons.restaurant_menu_rounded, 'Menu Pre-order',
                    p.preorder.isEmpty
                        ? 'Belum ada (pesan di tempat)'
                        : '${p.preorderText}\n${rupiah(p.preorderTotal)} (Bayar di Kasir)'),
                gap(6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: box(color: Colors.white, r: 14),
                  child: Row(children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.green),
                    gapW(8),
                    Expanded(child: Text('Biaya Booking Meja', style: ts(13, w: FontWeight.w700))),
                    Text('Rp 25.000',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                            decoration: TextDecoration.lineThrough)),
                    gapW(8),
                    Text('GRATIS', style: ts(14, w: FontWeight.w800, c: AppColors.green)),
                  ]),
                ),
              ]),
            ),
            gap(12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.surface, r: 18),
              child: Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: AppColors.greenSoft, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.chat_rounded, color: AppColors.green),
                ),
                gapW(12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Konfirmasi WhatsApp', style: ts(14, w: FontWeight.w800)),
                    Text(auth.user?.phone ?? '+62 812-4421-9870',
                        style: ts(11, c: AppColors.muted)),
                  ]),
                ),
                Switch(
                    value: p.whatsapp,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.green,
                    onChanged: p.setWhatsapp),
              ]),
            ),
            gap(14),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.green),
              gapW(4),
              Text('Reservasi Terverifikasi', style: ts(10, w: FontWeight.w700)),
              gapW(14),
              const Icon(Icons.history_rounded, size: 14, color: AppColors.primaryDark),
              gapW(4),
              Text('Batal Gratis s/d 1 Jam Sebelum', style: ts(10, w: FontWeight.w700)),
            ]),
          ]),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 16, offset: const Offset(0, -4)),
          ]),
          child: SafeArea(
            top: false,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Total Reservasi Meja', style: ts(10, c: AppColors.muted)),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('Rp 0', style: ts(18, w: FontWeight.w800, c: AppColors.primaryDark)),
                    gapW(4),
                    Text('(Gratis Booking)', style: ts(10, c: AppColors.muted)),
                  ]),
                ]),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(children: [
                    const Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.green),
                    gapW(4),
                    Text('Jaminan Meja 100%', style: ts(10, w: FontWeight.w800, c: AppColors.green)),
                  ]),
                  Text('Konfirmasi langsung via Resto', style: ts(10, c: AppColors.muted)),
                ]),
              ]),
              gap(8),
              PrimaryButton(
                  label: 'Konfirmasi Reservasi Meja Sekarang',
                  icon: Icons.event_available_rounded,
                  height: 52,
                  onPressed: () => _submit(context)),
            ]),
          ),
        ),
      ]),
    );
  }
}