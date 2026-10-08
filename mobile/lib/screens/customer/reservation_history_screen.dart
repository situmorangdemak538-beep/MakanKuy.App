import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/reservation.dart';
import '../../providers/reservation_provider.dart';

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({super.key});
  @override
  State<ReservationHistoryScreen> createState() => _ReservationHistoryScreenState();
}

class _ReservationHistoryScreenState extends State<ReservationHistoryScreen> {
  bool _active = true;

  Widget _tab(String label, int count, bool sel, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(label,
                  style: ts(13, w: FontWeight.w800, c: sel ? AppColors.primaryDark : AppColors.muted)),
              gapW(6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: sel ? AppColors.primaryDark : AppColors.border,
                    borderRadius: BorderRadius.circular(10)),
                child: Text('$count',
                    style: ts(10, w: FontWeight.w800, c: sel ? Colors.white : AppColors.ink)),
              ),
            ]),
          ),
        ),
      );

  Widget _step(String title, String sub, int state, {bool last = false}) {
    // state: 0 = selesai, 1 = sedang berjalan, 2 = belum
    final color = state == 0 ? AppColors.green : (state == 1 ? AppColors.primaryDark : AppColors.border);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(state == 0 ? Icons.check_rounded : Icons.qr_code_2_rounded,
              color: Colors.white, size: 18),
        ),
        if (!last) Container(width: 2, height: 26, color: state == 0 ? AppColors.green : AppColors.border),
      ]),
      gapW(12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: ts(14, w: FontWeight.w800, c: state == 1 ? AppColors.primaryDark : AppColors.ink)),
            Text(sub, style: ts(11, c: AppColors.muted)),
          ]),
        ),
      ),
    ]);
  }

  (String, Color, Color, IconData) _status(ReservationStatus s) {
    switch (s) {
      case ReservationStatus.pending:
        return ('Menunggu Konfirmasi', AppColors.amberSoft, const Color(0xFF6B4400), Icons.hourglass_top_rounded);
      case ReservationStatus.confirmed:
        return ('Terkonfirmasi', AppColors.greenSoft, AppColors.green, Icons.check_circle_rounded);
      case ReservationStatus.completed:
        return ('Selesai', AppColors.surface, AppColors.muted, Icons.task_alt_rounded);
      case ReservationStatus.cancelled:
        return ('Dibatalkan', AppColors.redSoft, AppColors.red, Icons.cancel_rounded);
    }
  }

  Widget _card(BuildContext context, Reservation r) {
    final st = _status(r.status);
    final p = context.read<ReservationProvider>();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(14), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Pill(text: st.$1, bg: st.$2, fg: st.$3, icon: st.$4, fontSize: 12),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: box(color: AppColors.surface, r: 16),
            child: Row(children: [
              Text('#${r.code}', style: ts(11, w: FontWeight.w800)),
              gapW(6),
              const Icon(Icons.qr_code_2_rounded, size: 18, color: AppColors.primaryDark),
            ]),
          ),
        ]),
        gap(14),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FoodImage(path: r.restaurantImage, width: 76, height: 76, radius: 14),
          gapW(12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Pill(text: 'Resto UMKM Unggulan', bg: AppColors.peach, fg: AppColors.primaryDark, fontSize: 10),
              gap(4),
              Text(r.restaurantName, style: ts(16, w: FontWeight.w800, h: 1.2)),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 13, color: AppColors.primaryDark),
                Expanded(
                    child: Text(r.restaurantAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ts(11, c: AppColors.muted))),
              ]),
            ]),
          ),
        ]),
        gap(14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: box(color: AppColors.surface, r: 16),
          child: Row(children: [
            Expanded(
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.calendar_month_outlined, color: AppColors.primaryDark, size: 20),
                ),
                gapW(8),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Jadwal Makan', style: ts(10, c: AppColors.muted)),
                    Text(dateLabel(r.date), style: ts(12, w: FontWeight.w800)),
                    Text('${r.time} WIT', style: ts(11, w: FontWeight.w800, c: AppColors.primaryDark)),
                  ]),
                ),
              ]),
            ),
            Expanded(
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: AppColors.amberSoft, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.event_seat_outlined, color: AppColors.primaryDark, size: 20),
                ),
                gapW(8),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Meja & Tamu', style: ts(10, c: AppColors.muted)),
                    Text(r.tableLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ts(12, w: FontWeight.w800)),
                    Text('${r.guests} Orang', style: ts(11, c: AppColors.muted)),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
        if (r.isActive) ...[
          gap(16),
          Text('Status Alur Kedatangan', style: ts(12, c: AppColors.muted)),
          gap(10),
          _step('Booking Diajukan', 'Selesai • ${r.agoLabel.isEmpty ? '14:20' : r.agoLabel}', 0),
          _step('Disetujui Resto UMKM',
              r.status == ReservationStatus.confirmed ? 'Meja telah disiapkan • 14:25 WIT' : 'Menunggu persetujuan resto',
              r.status == ReservationStatus.confirmed ? 0 : 1),
          _step('Tiba di Resto & Tunjukkan QR', 'Menunggu kedatangan Anda di lokasi',
              r.status == ReservationStatus.confirmed ? 1 : 2,
              last: true),
          gap(16),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => toast(context, 'Membuka petunjuk arah...'),
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: Text('Petunjuk Arah', style: ts(13, w: FontWeight.w800, c: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                ),
              ),
            ),
            gapW(10),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => toast(context, 'Chat resto segera hadir'),
                  icon: const Icon(Icons.chat_outlined, size: 18),
                  label: Text('Chat Resto', style: ts(13, w: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.ink,
                      elevation: 0,
                      shape: const StadiumBorder()),
                ),
              ),
            ),
          ]),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Batalkan reservasi?'),
                    content: Text('Reservasi ${r.code} di ${r.restaurantName} akan dibatalkan.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Tidak')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ya, Batalkan')),
                    ],
                  ),
                );
                if (ok == true) p.cancel(r);
              },
              icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.muted),
              label: Text('Ubah Jadwal atau Batalkan', style: ts(12, w: FontWeight.w700, c: AppColors.muted)),
            ),
          ),
        ],
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReservationProvider>();
    final list = _active ? rp.active : rp.done;
    return Scaffold(
      body: Column(children: [
        const BrandHeader(eyebrow: 'MAKANKUY TERNATE', title: 'Riwayat Reservasi'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: box(color: AppColors.surface, r: 28),
            child: Row(children: [
              _tab('Reservasi Aktif', rp.active.length, _active, () => setState(() => _active = true)),
              _tab('Riwayat Selesai', rp.done.length, !_active, () => setState(() => _active = false)),
            ]),
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(child: Text('Belum ada reservasi', style: ts(14, c: AppColors.muted)))
              : ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 16), children: [
                  ...list.map((r) => _card(context, r)),
                  if (_active)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: box(color: AppColors.peach, r: 20),
                      child: Row(children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              color: AppColors.amberSoft, borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.wb_twilight_rounded, color: AppColors.primaryDark),
                        ),
                        gapW(12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Tips Senja Ternate', style: ts(14, w: FontWeight.w800)),
                            Text('Datang 15 menit lebih awal untuk menikmati matahari terbenam berlatar Pulau Tidore langsung dari meja Anda.',
                                style: ts(12, c: AppColors.muted, h: 1.4)),
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