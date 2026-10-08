import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/reservation.dart';
import '../../providers/reservation_provider.dart';
import 'admin_shell.dart';

class AdminReservationsScreen extends StatefulWidget {
  const AdminReservationsScreen({super.key});
  @override
  State<AdminReservationsScreen> createState() => _AdminReservationsScreenState();
}

class _AdminReservationsScreenState extends State<AdminReservationsScreen> {
  int _tab = 0;

  Widget _info(IconData i, Color bg, String label, String value, {Color? vc}) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: box(color: Colors.white, r: 14),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(i, size: 18, color: AppColors.primaryDark),
          ),
          gapW(10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: ts(10, c: AppColors.muted)),
              Text(value, style: ts(13, w: FontWeight.w800, c: vc)),
            ]),
          ),
        ]),
      );

  Widget _card(BuildContext context, Reservation r) {
    final p = context.read<ReservationProvider>();
    final pending = r.status == ReservationStatus.pending;
    final confirmed = r.status == ReservationStatus.confirmed;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Container(height: 5, color: AppColors.primary),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Pill(text: '#${r.code}', bg: AppColors.border, fg: AppColors.ink, fontSize: 10),
              gapW(6),
              if (r.agoLabel.isNotEmpty)
                Pill(text: r.agoLabel, bg: AppColors.redSoft, fg: AppColors.red, icon: Icons.schedule_rounded, fontSize: 10),
              if (r.tag.isNotEmpty) ...[
                gapW(6),
                Pill(text: r.tag, bg: AppColors.amberSoft, fg: const Color(0xFF6B4400), fontSize: 10),
              ],
              const Spacer(),
              if (r.loyalty.isNotEmpty)
                Pill(text: 'WhatsApp', bg: AppColors.greenSoft, fg: AppColors.green, icon: Icons.chat_rounded, fontSize: 10)
              else
                const Icon(Icons.chat_outlined, color: AppColors.muted),
            ]),
            gap(8),
            Text(r.customerName, style: ts(20, w: FontWeight.w800)),
            Text(r.loyalty.isNotEmpty ? '★ ${r.loyalty}' : r.phone,
                style: ts(12, w: FontWeight.w700, c: r.loyalty.isNotEmpty ? AppColors.primaryDark : AppColors.muted)),
            gap(10),
            _info(Icons.event_available_outlined, AppColors.redSoft, 'Jadwal Kedatangan',
                '${relDay(r.date)} • ${r.time} WIT'),
            _info(Icons.event_seat_outlined, AppColors.amberSoft, 'Kapasitas & Lokasi Meja',
                '${r.guests} Orang • ${r.tableLabel}', vc: AppColors.green),
            _info(Icons.restaurant_menu_rounded, AppColors.border, 'Pre-order Menu',
                r.preorderText.isEmpty ? 'Belum memilih menu (Pesan di tempat)' : r.preorderText),
            if (r.note.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: box(color: AppColors.border, r: 12),
                child: Text('“${r.note}”', style: ts(12, c: AppColors.muted, h: 1.4)),
              ),
            gap(4),
            if (pending)
              Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        p.approve(r);
                        toast(context, 'Reservasi ${r.code} disetujui');
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                      label: Text(r.preorderText.isEmpty ? 'Setujui' : 'Setujui & Siapkan',
                          style: ts(13, w: FontWeight.w800, c: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    ),
                  ),
                ),
                gapW(10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => p.reject(r),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: Text('Tolak', style: ts(13, w: FontWeight.w800, c: AppColors.red)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redSoft,
                        foregroundColor: AppColors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                  ),
                ),
              ])
            else if (confirmed)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => p.complete(r),
                  icon: const Icon(Icons.task_alt_rounded, size: 18),
                  label: Text('Tandai Selesai', style: ts(13, w: FontWeight.w800, c: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                ),
              )
            else
              Pill(
                  text: r.status == ReservationStatus.completed ? 'Selesai' : 'Ditolak / Dibatalkan',
                  bg: r.status == ReservationStatus.completed ? AppColors.greenSoft : AppColors.redSoft,
                  fg: r.status == ReservationStatus.completed ? AppColors.green : AppColors.red),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReservationProvider>();
    final lists = [rp.pending, rp.approved, rp.finished];
    final labels = ['Menunggu Konfirmasi', 'Disetujui Hari Ini', 'Selesai'];
    final list = lists[_tab];

    return Scaffold(
      body: Column(children: [
        const AdminHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('Kelola Reservasi', style: ts(20, w: FontWeight.w800)),
                  gapW(6),
                  const Icon(Icons.circle, size: 8, color: AppColors.primary),
                ]),
                Text('Pantau & atur meja masuk secara real-time', style: ts(11, c: AppColors.muted)),
              ]),
            ),
            ElevatedButton.icon(
              onPressed: () => toast(context, 'Filter waktu segera hadir'),
              icon: const Icon(Icons.tune_rounded, size: 16),
              label: Text('Filter Waktu', style: ts(12, w: FontWeight.w800)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.ink,
                  elevation: 0,
                  shape: const StadiumBorder()),
            ),
          ]),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            for (var i = 0; i < 3; i++) ...[
              GestureDetector(
                onTap: () => setState(() => _tab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: box(color: _tab == i ? AppColors.primary : AppColors.surface, r: 24),
                  child: Row(children: [
                    Text(labels[i],
                        style: ts(13, w: FontWeight.w800, c: _tab == i ? Colors.white : AppColors.ink)),
                    gapW(6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: _tab == i ? Colors.white.withAlpha(60) : AppColors.border,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('${lists[i].length}',
                          style: ts(10, w: FontWeight.w800, c: _tab == i ? Colors.white : AppColors.ink)),
                    ),
                  ]),
                ),
              ),
              gapW(8),
            ],
          ]),
        ),
        gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: box(color: AppColors.surface, r: 16),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
                child: const Icon(Icons.verified_outlined, size: 18, color: AppColors.green),
              ),
              gapW(10),
              Expanded(
                child: Text('Sistem mengirimkan Auto-reminder WhatsApp tiket otomatis ke tamu begitu pesanan Anda setujui.',
                    style: ts(11, h: 1.4)),
              ),
            ]),
          ),
        ),
        gap(10),
        Expanded(
          child: list.isEmpty
              ? Center(child: Text('Tidak ada reservasi', style: ts(14, c: AppColors.muted)))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: list.map((r) => _card(context, r)).toList(),
                ),
        ),
      ]),
    );
  }
}