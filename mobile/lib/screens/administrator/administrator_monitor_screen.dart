import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/admin_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../data/models/reservation.dart';
import '../../providers/reservation_provider.dart';
 
/// Monitoring seluruh reservasi lintas restoran.
class AdministratorMonitorScreen extends StatefulWidget {
  const AdministratorMonitorScreen({super.key});
  @override
  State<AdministratorMonitorScreen> createState() => _AdministratorMonitorScreenState();
}
 
class _AdministratorMonitorScreenState extends State<AdministratorMonitorScreen> {
  ReservationStatus? _f;
 
  (String, Color, Color) _st(ReservationStatus s) => switch (s) {
        ReservationStatus.pending => ('Menunggu', AppColors.amberSoft, const Color(0xFF6B4400)),
        ReservationStatus.confirmed => ('Terkonfirmasi', AppColors.greenSoft, AppColors.green),
        ReservationStatus.completed => ('Selesai', AdminColors.indigoSoft, AdminColors.indigo),
        ReservationStatus.cancelled => ('Batal / Ditolak', AppColors.redSoft, AppColors.red),
      };
 
  @override
  Widget build(BuildContext context) {
    final all = context.watch<ReservationProvider>().everything;
    final list = _f == null ? all : all.where((r) => r.status == _f).toList();
    int count(ReservationStatus s) => all.where((r) => r.status == s).length;
 
    return Scaffold(
      backgroundColor: AdminColors.bg,
      appBar: AppBar(
        backgroundColor: AdminColors.navy,
        foregroundColor: Colors.white,
        title: Text('Monitoring Reservasi', style: ts(17, w: FontWeight.w800, c: Colors.white)),
      ),
      body: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            FilterPill(label: 'Semua (${all.length})', selected: _f == null, selBg: AdminColors.indigo, onTap: () => setState(() => _f = null)),
            for (final s in ReservationStatus.values) ...[
              gapW(8),
              FilterPill(label: '${_st(s).$1} (${count(s)})', selected: _f == s, selBg: AdminColors.indigo, onTap: () => setState(() => _f = s)),
            ],
          ]),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(child: Text('Tidak ada data', style: ts(13, c: AppColors.muted)))
              : ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 20), children: [
                  for (final r in list)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: box(color: Colors.white, r: 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text('#${r.code}', style: ts(11, w: FontWeight.w800, c: AppColors.muted)),
                          const Spacer(),
                          Pill(text: _st(r.status).$1, bg: _st(r.status).$2, fg: _st(r.status).$3, fontSize: 10),
                        ]),
                        gap(4),
                        Text(r.restaurantName, style: ts(14, w: FontWeight.w800)),
                        Text(
                            '${r.customerName.isEmpty ? 'Pelanggan' : r.customerName} • ${r.guests} orang • ${r.dateText} • ${r.time} WIT',
                            style: ts(11, c: AppColors.muted)),
                        if (r.exclusive)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Pill(text: 'Booking seluruh tempat', bg: AppColors.amberSoft, fg: Color(0xFF6B4400), icon: Icons.lock_rounded, fontSize: 10),
                          ),
                      ]),
                    ),
                ]),
        ),
      ]),
    );
  }
}