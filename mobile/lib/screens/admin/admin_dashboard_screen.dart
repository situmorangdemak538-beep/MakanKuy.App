import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../data/models/reservation.dart';
import '../../providers/nav_provider.dart';
import '../../providers/reservation_provider.dart';
import 'admin_shell.dart';

class _Table {
  final String name, spec, note;
  final int status; // 0 = terisi, 1 = kosong, 2 = booking
  final String? time;
  const _Table(this.name, this.spec, this.status, this.note, {this.time});
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const _tables = [
    _Table('Meja 01', 'Indoor AC • 4 Kursi', 0, 'Makan di tempat'),
    _Table('Meja 02', 'Indoor AC • 4 Kursi', 1, 'Siap ditempati'),
    _Table('Meja 06', 'Lesehan Laut • 6 Kursi', 2, 'Farhan A. (4 Tamu)', time: '19:00 WIT'),
    _Table('Gazebo Kenari', 'Outdoor Teduh • 4 Kursi', 1, 'Booking 18:30 nanti'),
  ];

  Widget _stat(IconData i, Color bg, String label, String value, String sub,
      {Widget? badge, Color? card, Color? subColor, Widget? extra}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: box(color: card ?? AppColors.surface, r: 22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(i, size: 18, color: AppColors.primaryDark),
          ),
          const Spacer(),
          if (badge != null) badge,
        ]),
        gap(8),
        Text(label, style: ts(11, c: AppColors.muted)),
        Text(value, style: ts(19, w: FontWeight.w800)),
        if (extra != null) extra,
        Text(sub, style: ts(11, w: FontWeight.w700, c: subColor ?? AppColors.green)),
      ]),
    );
  }

  Widget _tableCard(_Table t) {
    final color = t.status == 0 ? AppColors.primary : (t.status == 1 ? AppColors.green : AppColors.amber);
    final label = t.status == 0 ? 'Terisi' : (t.status == 1 ? 'Kosong' : (t.time ?? 'Booking'));
    final labelBg = t.status == 0 ? AppColors.primaryDark : (t.status == 1 ? AppColors.greenSoft : AppColors.amberSoft);
    final labelFg = t.status == 0 ? Colors.white : (t.status == 1 ? AppColors.green : const Color(0xFF6B4400));
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: t.status == 0 ? AppColors.border : Colors.white,
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(t.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(14, w: FontWeight.w800))),
                  Pill(text: label, bg: labelBg, fg: labelFg, fontSize: 9),
                ]),
                gap(2),
                Text(t.spec, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(10, c: AppColors.muted)),
                gap(6),
                Text(t.note, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: ts(10, w: FontWeight.w800, c: t.status == 1 ? AppColors.green : AppColors.primaryDark)),
              ]),
            ),
          ),
          Container(width: 5, color: color),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReservationProvider>();
    final nav = context.read<NavProvider>();
    final pending = rp.pending;
    final first = pending.isEmpty ? null : pending.first;

    Widget actionBtn(IconData i, String t, bool primary, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(i, size: 18),
            label: Text(t, style: ts(13, w: FontWeight.w800, c: primary ? Colors.white : AppColors.ink)),
            style: ElevatedButton.styleFrom(
                backgroundColor: primary ? AppColors.primary : AppColors.surface,
                foregroundColor: primary ? Colors.white : AppColors.ink,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: const StadiumBorder()),
          ),
        );

    return Scaffold(
      body: Column(children: [
        const AdminHeader(),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
            Row(children: [
              const Icon(Icons.circle, size: 9, color: AppColors.green),
              gapW(6),
              Text('BUKA OPERASIONAL', style: ts(11, w: FontWeight.w800, c: AppColors.green)),
              const Spacer(),
              const Pill(text: '10:00 - 22:00 WIT', bg: AppColors.surface, fg: AppColors.ink, fontSize: 11),
            ]),
            gap(4),
            Text('Ringkasan Hari Ini', style: ts(24, w: FontWeight.w800)),
            Text('Jl. Pahlawan Revolusi, Ternate Tengah • Gamalama', style: ts(12, c: AppColors.muted)),
            gap(14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.08,
              children: [
                _stat(Icons.calendar_month_outlined, AppColors.peach, 'Total Reservasi',
                    '${rp.incoming.length + 14} Booking', 'Naik dibanding kemarin',
                    badge: const Pill(text: '↑ +4', bg: AppColors.greenSoft, fg: AppColors.green)),
                _stat(Icons.event_seat_outlined, AppColors.amberSoft, 'Okupansi Meja', '8 / 10 Meja', '',
                    badge: const Pill(text: '80%', bg: AppColors.amberSoft, fg: Color(0xFF6B4400)),
                    extra: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                            value: 0.8, minHeight: 6, backgroundColor: AppColors.border, color: AppColors.amber),
                      ),
                    )),
                _stat(Icons.payments_outlined, AppColors.greenSoft, 'Estimasi Omzet', 'Rp 1.850.000',
                    '14 reservasi santap',
                    badge: const Pill(text: 'Pre-order', bg: AppColors.border, fg: AppColors.muted)),
                _stat(Icons.notifications_active_outlined, Colors.white, 'Butuh Tindakan',
                    '${pending.length} Reservasi', 'Perlu respon segera',
                    card: AppColors.redSoft,
                    subColor: AppColors.red,
                    badge: const Icon(Icons.circle, size: 9, color: AppColors.red)),
              ],
            ),
            gap(14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                actionBtn(Icons.qr_code_scanner_rounded, 'Scan Tamu Tiba', true, () => toast(context, 'Pemindai QR segera hadir')),
                actionBtn(Icons.power_settings_new_rounded, 'Reservasi Buka', false, () => toast(context, 'Reservasi dibuka')),
                actionBtn(Icons.download_rounded, 'Ekspor Laporan', false, () => toast(context, 'Ekspor segera hadir')),
              ]),
            ),
            gap(20),
            const SectionTitle(title: 'Denah & Status Meja', action: 'Lihat Semua (10)'),
            gap(10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.surface, r: 22),
              child: Column(children: [
                Row(children: [
                  for (final l in [('Tersedia', AppColors.green), ('Terisi', AppColors.primary), ('Booking', AppColors.amber)]) ...[
                    Icon(Icons.circle, size: 9, color: l.$2),
                    gapW(4),
                    Text(l.$1, style: ts(11)),
                    gapW(10),
                  ],
                  const Spacer(),
                  const Pill(text: 'Live Monitor', bg: AppColors.border, fg: AppColors.muted),
                ]),
                gap(10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.6,
                  children: _tables.map(_tableCard).toList(),
                ),
              ]),
            ),
            gap(20),
            SectionTitle(title: 'Aktivitas Reservasi Terkini'),
            gap(10),
            if (first != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: box(color: AppColors.surface, r: 22),
                child: Column(children: [
                  Row(children: [
                    CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.peach,
                        child: Text(first.customerName.isEmpty ? '?' : first.customerName[0],
                            style: ts(14, w: FontWeight.w800, c: AppColors.primaryDark))),
                    gapW(10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(first.customerName, style: ts(14, w: FontWeight.w800)),
                        Text('${first.tableLabel} • ${first.guests} orang',
                            style: ts(11, c: AppColors.muted)),
                      ]),
                    ),
                    const Pill(text: 'Menunggu Respon', bg: AppColors.amberSoft, fg: Color(0xFF6B4400), fontSize: 10),
                  ]),
                  gap(10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: box(color: AppColors.border, r: 12),
                    child: Row(children: [
                      const Icon(Icons.schedule_rounded, size: 15, color: AppColors.muted),
                      gapW(6),
                      Text('Rencana Hadir: ${first.time} WIT', style: ts(11)),
                      const Spacer(),
                      Text(
                          first.preorderText.isEmpty ? 'Tanpa pre-order' : 'Pre-order: ${first.preorder_count} Menu',
                          style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark)),
                    ]),
                  ),
                  gap(10),
                  Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => rp.approve(first),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          child: Text('Terima Booking', style: ts(13, w: FontWeight.w800, c: Colors.white)),
                        ),
                      ),
                    ),
                    gapW(10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => nav.go(1),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.border,
                              foregroundColor: AppColors.ink,
                              elevation: 0,
                              shape: const StadiumBorder()),
                          child: Text('Atur Meja Lain', style: ts(13, w: FontWeight.w800)),
                        ),
                      ),
                    ),
                  ]),
                ]),
              )
            else
              Container(
                padding: const EdgeInsets.all(18),
                decoration: box(color: AppColors.surface, r: 22),
                child: Center(child: Text('Tidak ada reservasi menunggu respon', style: ts(13, c: AppColors.muted))),
              ),
            gap(10),
            ...rp.approved.take(2).map((r) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: box(color: AppColors.surface, r: 20),
                  child: Row(children: [
                    CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.greenSoft,
                        child: Text(r.customerName.isEmpty ? '?' : r.customerName.substring(0, r.customerName.length >= 2 ? 2 : 1).toUpperCase(),
                            style: ts(13, w: FontWeight.w800, c: AppColors.green))),
                    gapW(10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(r.customerName, style: ts(14, w: FontWeight.w800)),
                        Text('${r.tableLabel} • ${r.guests} orang', style: ts(11, c: AppColors.muted)),
                        Text('Terkonfirmasi', style: ts(11, w: FontWeight.w700, c: AppColors.green)),
                      ]),
                    ),
                    Pill(text: '${r.time} WIT', bg: AppColors.border, fg: AppColors.ink),
                  ]),
                )),
            gap(10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(color: AppColors.border, r: 20),
              child: Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primaryDark),
                ),
                gapW(12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Wawasan Mitra Ternate', style: ts(13, w: FontWeight.w800)),
                    Text('Waktu reservasi puncak di Ternate adalah saat Matahari Terbenam (18:00 - 19:30 WIT). Siapkan racikan rica dan kuah fufu lebih awal!',
                        style: ts(11, c: AppColors.muted, h: 1.4)),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

extension on Reservation {
  int get preorder_count =>
      preorderText.isEmpty ? 0 : preorderText.split(',').length;
}