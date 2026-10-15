import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/availability_provider.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import 'common.dart';

/// Kalender ketersediaan restoran.
///  - Putih            : tanggal tersedia
///  - Merah (dicoret)  : PENUH, terkunci
///  - Kuning + gembok  : sudah DIPESAN klien lain, terkunci
///  - Oranye           : pilihanmu (allowRange = true -> bisa pilih periode awal s/d akhir)
class AvailabilityCalendar extends StatefulWidget {
  final String restaurantId;
  final DateTime? start, end;
  final bool allowRange;
  final bool autoSelect;
  final void Function(DateTime start, DateTime? end) onChanged;

  const AvailabilityCalendar({
    super.key,
    required this.restaurantId,
    required this.onChanged,
    this.start,
    this.end,
    this.allowRange = false,
    this.autoSelect = true,
  });

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _month = DateTime(n.year, n.month);
    if (widget.autoSelect) {
      // Bila tanggal bawaan ternyata terkunci, pindahkan ke tanggal kosong terdekat.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final av = context.read<AvailabilityProvider>();
        final s = widget.start;
        if (s == null || av.statusOf(widget.restaurantId, s) != DayStatus.free) {
          final f = av.firstFree(widget.restaurantId);
          if (f != null) widget.onChanged(f, null);
        }
      });
    }
  }

  void _tap(AvailabilityProvider av, DateTime d) {
    final st = av.statusOf(widget.restaurantId, d);
    if (st == DayStatus.past) return;
    if (st == DayStatus.full) {
      toast(context, 'Tanggal ini sudah penuh');
      return;
    }
    if (st == DayStatus.booked) {
      toast(context, 'Tanggal ini sudah dipesan klien lain');
      return;
    }
    final s = widget.start, e = widget.end;
    if (!widget.allowRange || s == null || e != null || d.isBefore(s) || isSameDay(d, s)) {
      widget.onChanged(d, null);
      return;
    }
    if (!av.rangeFree(widget.restaurantId, s, d)) {
      toast(context, 'Periode ini mencakup tanggal yang terkunci');
      widget.onChanged(d, null);
      return;
    }
    widget.onChanged(s, d);
  }

  Widget _cell(AvailabilityProvider av, DateTime d) {
    final st = av.statusOf(widget.restaurantId, d);
    final s = widget.start, e = widget.end;
    final isEdge = (s != null && isSameDay(d, s)) || (e != null && isSameDay(d, e));
    final inRange = s != null && e != null && d.isAfter(s) && d.isBefore(e);

    Color bg = Colors.white;
    Color fg = AppColors.ink;
    IconData? ic;
    TextDecoration? dec;
    if (st == DayStatus.past) {
      bg = Colors.transparent;
      fg = AppColors.border;
    } else if (st == DayStatus.full) {
      bg = AppColors.redSoft;
      fg = AppColors.red;
      dec = TextDecoration.lineThrough;
    } else if (st == DayStatus.booked) {
      bg = AppColors.amberSoft;
      fg = const Color(0xFF6B4400);
      ic = Icons.lock_rounded;
    }
    if (isEdge) {
      bg = AppColors.primary;
      fg = Colors.white;
      ic = null;
      dec = null;
    } else if (inRange) {
      bg = AppColors.peach;
      fg = AppColors.primaryDark;
    }

    return GestureDetector(
      onTap: () => _tap(av, d),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: (st == DayStatus.free && !isEdge && !inRange)
              ? Border.all(color: AppColors.border)
              : null,
        ),
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('${d.day}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: fg,
                  decoration: dec)),
          if (ic != null) Icon(ic, size: 10, color: fg),
        ]),
      ),
    );
  }

  Widget _legend(Color c, String t, {Color? border}) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(4),
              border: border == null ? null : Border.all(color: border)),
        ),
        gapW(4),
        Text(t, style: ts(10, c: AppColors.muted)),
      ]);

  @override
  Widget build(BuildContext context) {
    final av = context.watch<AvailabilityProvider>();
    final now = DateTime.now();
    final cur = DateTime(now.year, now.month);
    final last = DateTime(now.year, now.month + 2);
    final lead = DateTime(_month.year, _month.month, 1).weekday - 1;
    final total = DateTime(_month.year, _month.month + 1, 0).day;
    final free14 = av.freeCount(widget.restaurantId, 14);
    final next = av.firstFree(widget.restaurantId);
    final s = widget.start, e = widget.end;

    return Column(children: [
      Row(children: [
        IconButton(
            onPressed: _month.isAfter(cur)
                ? () => setState(() => _month = DateTime(_month.year, _month.month - 1))
                : null,
            icon: const Icon(Icons.chevron_left_rounded)),
        Expanded(
          child: Text('${monthLong(_month)} ${_month.year}',
              textAlign: TextAlign.center, style: ts(15, w: FontWeight.w800)),
        ),
        IconButton(
            onPressed: _month.isBefore(last)
                ? () => setState(() => _month = DateTime(_month.year, _month.month + 1))
                : null,
            icon: const Icon(Icons.chevron_right_rounded)),
      ]),
      Row(
        children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
            .map((h) => Expanded(
                child: Center(
                    child: Text(h, style: ts(11, w: FontWeight.w700, c: AppColors.muted)))))
            .toList(),
      ),
      gap(6),
      GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.95,
        children: [
          for (var i = 0; i < lead; i++) const SizedBox.shrink(),
          for (var d = 1; d <= total; d++)
            _cell(av, DateTime(_month.year, _month.month, d)),
        ],
      ),
      gap(10),
      Wrap(spacing: 12, runSpacing: 6, children: [
        _legend(Colors.white, 'Tersedia', border: AppColors.border),
        _legend(AppColors.redSoft, 'Penuh'),
        _legend(AppColors.amberSoft, 'Dipesan klien lain'),
        _legend(AppColors.primary, 'Pilihanmu'),
      ]),
      gap(10),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: box(color: Colors.white, r: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(free14 == 0 ? Icons.event_busy_rounded : Icons.event_available_rounded,
              size: 18, color: free14 == 0 ? AppColors.red : AppColors.green),
          gapW(8),
          Expanded(
            child: Text(
              free14 == 0
                  ? 'Semua tanggal 14 hari ke depan penuh/terpesan.${next == null ? '' : ' Tanggal kosong terdekat: ${next.day} ${monthShort(next)}.'}'
                  : '$free14 dari 14 hari ke depan masih tersedia.${s == null ? '' : '\nDipilih: ${s.day} ${monthShort(s)}${e == null ? '' : ' – ${e.day} ${monthShort(e)}'}'}',
              style: ts(11, c: AppColors.muted, h: 1.4),
            ),
          ),
        ]),
      ),
    ]);
  }
}