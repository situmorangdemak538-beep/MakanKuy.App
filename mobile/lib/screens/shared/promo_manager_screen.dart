import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/models/promo.dart';
import '../../providers/promo_provider.dart';
 
/// Kelola diskon/promo musiman. HANYA untuk Admin Restoran & Administrator.
///  - isAdministrator = true  : semua promo, bisa buat promo untuk SEMUA restoran
///  - isAdministrator = false : hanya promo warung milik restaurantId
class PromoManagerScreen extends StatelessWidget {
  final bool isAdministrator;
  final String? restaurantId;
  final Widget header;
  const PromoManagerScreen(
      {super.key,
      required this.isAdministrator,
      required this.header,
      this.restaurantId});
 
  String _status(Promo p) {
    final now = DateTime.now();
    if (!p.active) return 'Nonaktif';
    if (p.isRunning) return 'Berjalan';
    if (now.isBefore(p.start)) return 'Terjadwal';
    return 'Berakhir / Habis';
  }
 
  void _form(BuildContext context, {Promo? edit}) {
    final pp = context.read<PromoProvider>();
    final title = TextEditingController(text: edit?.title ?? '');
    final desc = TextEditingController(text: edit?.description ?? '');
    final quota = TextEditingController(text: '${edit?.quota ?? 50}');
    var occ = edit?.occasion ?? PromoOccasion.spesial;
    var percent = (edit?.percent ?? 20).toDouble();
    var range = DateTimeRange(
        start: edit?.start ?? DateTime.now(),
        end: edit?.end ?? DateTime.now().add(const Duration(days: 7)));
    var global = edit == null ? isAdministrator : edit.restaurantId == null;
 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(edit == null ? 'Buat Promo Baru' : 'Ubah Promo', style: ts(18, w: FontWeight.w800)),
              gap(12),
              Text('Momen / Hari Spesial', style: ts(12, w: FontWeight.w700, c: AppColors.muted)),
              gap(8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final o in PromoOccasion.values)
                  FilterPill(
                    label: o.label,
                    icon: o.icon,
                    selected: occ == o,
                    selBg: o.color,
                    onTap: () => setS(() {
                      occ = o;
                      if (edit == null) {
                        title.text = 'Promo ${o.label}';
                        range = o.suggestedRange; // tanggal musiman perkiraan
                      }
                    }),
                  ),
              ]),
              gap(12),
              TextField(controller: title, decoration: const InputDecoration(hintText: 'Judul promo')),
              gap(10),
              TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(hintText: 'Deskripsi singkat')),
              gap(12),
              Text('Besar diskon: ${percent.round()}%', style: ts(13, w: FontWeight.w800)),
              Slider(
                value: percent,
                min: 5,
                max: 70,
                divisions: 13,
                label: '${percent.round()}%',
                activeColor: AppColors.primary,
                onChanged: (v) => setS(() => percent = v),
              ),
              GestureDetector(
                onTap: () async {
                  final r = await showDateRangePicker(
                      context: ctx,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(DateTime.now().year + 3),
                      initialDateRange: range);
                  if (r != null) setS(() => range = r);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: box(color: AppColors.surface, r: 14),
                  child: Row(children: [
                    const Icon(Icons.date_range_rounded, color: AppColors.primaryDark),
                    gapW(10),
                    Expanded(
                        child: Text(
                            '${range.start.day} ${monthShort(range.start)} ${range.start.year} – ${range.end.day} ${monthShort(range.end)} ${range.end.year}',
                            style: ts(13, w: FontWeight.w800))),
                    const Icon(Icons.edit_calendar_rounded, size: 18, color: AppColors.muted),
                  ]),
                ),
              ),
              gap(10),
              TextField(
                  controller: quota,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Kuota kupon (jumlah voucher)')),
              gap(8),
              if (isAdministrator)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: global,
                  activeColor: AppColors.green,
                  title: Text('Berlaku di SEMUA restoran', style: ts(13, w: FontWeight.w800)),
                  onChanged: (v) => setS(() => global = v),
                )
              else
                Text('Promo ini berlaku untuk warung Anda.', style: ts(12, c: AppColors.muted)),
              gap(10),
              PrimaryButton(
                label: 'Simpan Promo',
                onPressed: () {
                  final q = int.tryParse(quota.text.trim()) ?? 0;
                  if (title.text.trim().isEmpty || q < 1) {
                    toast(ctx, 'Judul dan kuota (min. 1) wajib diisi');
                    return;
                  }
                  final scope = (isAdministrator && global) ? null : (restaurantId ?? 'r1');
                  if (edit == null) {
                    // Backend: POST /api/promos
                    pp.add(Promo(
                      id: 'p${DateTime.now().millisecondsSinceEpoch}',
                      title: title.text.trim(),
                      occasion: occ,
                      percent: percent.round(),
                      start: range.start,
                      end: range.end,
                      quota: q,
                      restaurantId: scope,
                      createdBy: isAdministrator ? 'administrator' : 'admin',
                      description: desc.text.trim(),
                    ));
                  } else {
                    // Backend: PUT /api/promos/{id}
                    edit.title = title.text.trim();
                    edit.description = desc.text.trim();
                    edit.occasion = occ;
                    edit.percent = percent.round();
                    edit.start = range.start;
                    edit.end = range.end;
                    edit.quota = q;
                    edit.restaurantId = scope;
                    pp.touch();
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
 
  Widget _item(BuildContext context, PromoProvider pp, Promo p) {
    final c = p.occasion.color;
    final status = _status(p);
    final progress = p.quota == 0 ? 0.0 : (p.claimed / p.quota).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: box(color: Colors.white, r: 20),
      child: Column(children: [
        Row(children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: c.withAlpha(35), shape: BoxShape.circle),
            child: Icon(p.occasion.icon, color: c),
          ),
          gapW(12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(14, w: FontWeight.w800)),
              Text('${p.occasion.label} • ${p.percent}% • ${p.restaurantId == null ? 'Semua restoran' : 'Warung tertentu'}',
                  style: ts(11, c: AppColors.muted)),
            ]),
          ),
          Switch(
              value: p.active,
              activeColor: Colors.white,
              activeTrackColor: AppColors.green,
              onChanged: (_) => pp.toggle(p)),
        ]),
        gap(6),
        Row(children: [
          const Icon(Icons.date_range_rounded, size: 15, color: AppColors.muted),
          gapW(6),
          Text(p.periodText, style: ts(11, c: AppColors.muted)),
        ]),
        gap(8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
              value: progress, minHeight: 6, backgroundColor: AppColors.border, color: c),
        ),
        gap(4),
        Row(children: [
          Text('${p.claimed}/${p.quota} diklaim', style: ts(11, w: FontWeight.w700)),
          gapW(8),
          Pill(
              text: status,
              bg: status == 'Berjalan' ? AppColors.greenSoft : (status == 'Terjadwal' ? AppColors.amberSoft : AppColors.surface),
              fg: status == 'Berjalan' ? AppColors.green : (status == 'Terjadwal' ? const Color(0xFF6B4400) : AppColors.muted),
              fontSize: 10),
          const Spacer(),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => _form(context, edit: p),
              icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primaryDark)),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Hapus promo?'),
                    content: Text('Promo "${p.title}" akan dihapus.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
                    ],
                  ),
                );
                if (ok == true) pp.remove(p);
              },
              icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.red)),
        ]),
      ]),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final pp = context.watch<PromoProvider>();
    final list = pp.manageable(isAdministrator: isAdministrator, restaurantId: restaurantId);
    return Scaffold(
      backgroundColor: isAdministrator ? const Color(0xFFF3F5FB) : AppColors.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _form(context),
        backgroundColor: isAdministrator ? const Color(0xFF4C6EF5) : AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('Buat Promo', style: ts(14, w: FontWeight.w800, c: Colors.white)),
      ),
      body: Column(children: [
        header,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Kelola Diskon & Promo', style: ts(20, w: FontWeight.w800)),
                Text('Ramadan, Natal, Imlek, Valentine, Hari Raya, dan hari spesial lainnya',
                    style: ts(11, c: AppColors.muted)),
              ]),
            ),
          ]),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(child: Text('Belum ada promo. Ketuk "Buat Promo".', style: ts(13, c: AppColors.muted)))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                  children: list.map((p) => _item(context, pp, p)).toList()),
        ),
      ]),
    );
  }
}