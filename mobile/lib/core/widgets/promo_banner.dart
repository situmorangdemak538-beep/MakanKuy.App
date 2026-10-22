import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/promo.dart';
import '../../providers/promo_provider.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import 'common.dart';

/// Banner promo di Beranda. Tampil otomatis dari promo yang sedang berjalan.
class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});
  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final _ctrl = PageController(viewportFraction: 0.94);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _card(BuildContext context, PromoProvider pp, Promo p) {
    final c = p.occasion.color;
    final done = pp.isClaimed(p.id);
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
            colors: [c, Color.lerp(c, Colors.black, 0.35)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Stack(children: [
        Positioned(
            right: 0,
            top: 0,
            child: Icon(p.occasion.icon, size: 84, color: Colors.white.withAlpha(40))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Pill(
              text: p.occasion.label.toUpperCase(),
              bg: Colors.white.withAlpha(60),
              fg: Colors.white,
              icon: p.occasion.icon),
          gap(8),
          Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(20, w: FontWeight.w800, c: Colors.white)),
          gap(4),
          Text(p.description.isEmpty ? 'Diskon ${p.percent}% sampai ${p.end.day} ${monthShort(p.end)}' : p.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: ts(12, c: Colors.white, h: 1.4)),
          const Spacer(),
          Row(children: [
            ElevatedButton.icon(
              onPressed: done
                  ? null
                  : () {
                      final ok = pp.claim(p);
                      toast(context, ok ? 'Voucher ${p.percent}% diklaim & siap dipakai saat reservasi' : 'Voucher tidak tersedia');
                    },
              icon: Icon(done ? Icons.check_rounded : Icons.confirmation_number_outlined, size: 18),
              label: Text(done ? 'Voucher Diklaim' : 'Klaim Voucher',
                  style: ts(13, w: FontWeight.w800, c: AppColors.ink)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.ink,
                  shape: const StadiumBorder()),
            ),
            gapW(10),
            Expanded(
                child: Text('Sisa ${p.remaining} Kupon • ${p.restaurantId == null ? 'Semua resto' : 'Resto tertentu'}',
                    style: ts(11, c: Colors.white))),
          ]),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<PromoProvider>();
    final list = pp.running;
    if (list.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 196,
      child: PageView(
        controller: _ctrl,
        padEnds: false,
        children: list.map((p) => _card(context, pp, p)).toList(),
      ),
    );
  }
}