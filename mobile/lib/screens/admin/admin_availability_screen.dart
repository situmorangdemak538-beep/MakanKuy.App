import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/availability_calendar.dart';
import '../../core/widgets/common.dart';
import '../../providers/availability_provider.dart';
 
/// Pengelola mengunci tanggal PENUH (acara pribadi, renovasi, libur, dst).
/// Tanggal terkunci otomatis tidak bisa dipilih customer di form reservasi.
class AdminAvailabilityScreen extends StatefulWidget {
  final String restaurantId;
  const AdminAvailabilityScreen({super.key, this.restaurantId = 'r1'});
  @override
  State<AdminAvailabilityScreen> createState() => _AdminAvailabilityScreenState();
}
 
class _AdminAvailabilityScreenState extends State<AdminAvailabilityScreen> {
  DateTime? _start, _end;
  final _reason = TextEditingController();
 
  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }
 
  String _range(DateTime s, DateTime e) => isSameDay(s, e)
      ? '${s.day} ${monthShort(s)} ${s.year}'
      : '${s.day} ${monthShort(s)} – ${e.day} ${monthShort(e)} ${e.year}';
 
  @override
  Widget build(BuildContext context) {
    final av = context.watch<AvailabilityProvider>();
    final locks = av.locksOf(widget.restaurantId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Atur Ketersediaan', style: ts(18, w: FontWeight.w800)),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: box(color: AppColors.amberSoft, r: 14),
          child: Row(children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.primaryDark),
            gapW(10),
            Expanded(
                child: Text('Pilih satu tanggal atau periode (ketuk tanggal awal lalu akhir), kemudian kunci sebagai PENUH.',
                    style: ts(12, h: 1.4))),
          ]),
        ),
        gap(12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: box(color: AppColors.surface, r: 20),
          child: AvailabilityCalendar(
            restaurantId: widget.restaurantId,
            start: _start,
            end: _end,
            allowRange: true,
            autoSelect: false,
            onChanged: (s, e) => setState(() {
              _start = s;
              _end = e;
            }),
          ),
        ),
        gap(12),
        TextField(
            controller: _reason,
            decoration: const InputDecoration(hintText: 'Alasan (acara pribadi, renovasi, libur...)')),
        gap(10),
        PrimaryButton(
          label: _start == null ? 'Pilih tanggal dulu' : 'Kunci ${_range(_start!, _end ?? _start!)}',
          icon: Icons.lock_rounded,
          color: AppColors.red,
          onPressed: _start == null
              ? null
              : () {
                  // Backend: POST /api/restaurants/{id}/locks
                  av.lock(widget.restaurantId, _start!, _end ?? _start!,
                      'manual-${DateTime.now().millisecondsSinceEpoch}',
                      booked: false,
                      reason: _reason.text.trim().isEmpty ? 'Penuh' : _reason.text.trim());
                  _reason.clear();
                  setState(() {
                    _start = null;
                    _end = null;
                  });
                  toast(context, 'Tanggal berhasil dikunci');
                },
        ),
        gap(20),
        Text('Tanggal Terkunci', style: ts(16, w: FontWeight.w800)),
        gap(8),
        if (locks.isEmpty) Text('Belum ada tanggal terkunci.', style: ts(12, c: AppColors.muted)),
        ...locks.map((l) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.surface, r: 16),
              child: Row(children: [
                Icon(l.booked ? Icons.lock_rounded : Icons.event_busy_rounded,
                    color: l.booked ? const Color(0xFF6B4400) : AppColors.red),
                gapW(10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_range(l.start, l.end), style: ts(13, w: FontWeight.w800)),
                    Text(l.reason, style: ts(11, c: AppColors.muted)),
                  ]),
                ),
                if (l.booked)
                  const Pill(text: 'Dipesan klien', bg: AppColors.amberSoft, fg: Color(0xFF6B4400), fontSize: 10)
                else
                  IconButton(
                      onPressed: () => av.unlock(l.code),
                      icon: const Icon(Icons.lock_open_rounded, color: AppColors.green)),
              ]),
            )),
      ]),
    );
  }
}