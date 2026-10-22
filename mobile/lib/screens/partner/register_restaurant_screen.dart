import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../data/models/restaurant.dart';
import '../../data/models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/system_provider.dart';
 
/// Dipanggil dari: tombol "Gabung Mitra" (Beranda), "Daftarkan Warung" (Profil customer),
/// Profil Admin Restoran, dan Dashboard Administrator.
void openRegisterRestaurant(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => const RegisterRestaurantScreen()));
}
 
class RegisterRestaurantScreen extends StatefulWidget {
  const RegisterRestaurantScreen({super.key});
  @override
  State<RegisterRestaurantScreen> createState() => _RegisterRestaurantScreenState();
}
 
class _RegisterRestaurantScreenState extends State<RegisterRestaurantScreen> {
  static const _allDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const _areas = ['Ternate Tengah', 'Ternate Selatan', 'Ternate Utara', 'Pulau Ternate'];
  static const _facilities = ['WiFi Gratis', 'AC', 'View Laut', 'Musholla', 'Parkir Luas', 'Live Music', 'Toilet Bersih'];
  static const _types = ['Indoor AC', 'Lesehan', 'Outdoor / Gazebo'];
 
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _addr = TextEditingController();
  final _wa = TextEditingController();
  final _desc = TextEditingController();
  final _pf = TextEditingController();
  final _pt = TextEditingController();
 
  String? _cat;
  String _area = 'Ternate Tengah';
  int _tables = 10;
  int _seats = 4;
  final Set<String> _days = {..._allDays};
  final Set<String> _fac = {};
  final Set<String> _type = {'Indoor AC'};
  TimeOfDay _open = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _close = const TimeOfDay(hour: 22, minute: 0);
  bool _agree = true;
 
  @override
  void dispose() {
    for (final c in [_name, _addr, _wa, _desc, _pf, _pt]) {
      c.dispose();
    }
    super.dispose();
  }
 
  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
 
  Future<void> _pickTime(bool isOpen) async {
    final t = await showTimePicker(context: context, initialTime: isOpen ? _open : _close);
    if (t == null) return;
    setState(() {
      if (isOpen) {
        _open = t;
      } else {
        _close = t;
      }
    });
  }
 
  void _submit() {
    if (!_form.currentState!.validate()) return;
    if (_cat == null) return toast(context, 'Pilih kategori masakan');
    if (_days.isEmpty) return toast(context, 'Pilih minimal satu hari buka');
    if (!_agree) return toast(context, 'Setujui Syarat Mitra terlebih dahulu');
 
    final auth = context.read<AuthProvider>();
    final isAdministrator = auth.user?.role == AppRole.administrator;
    final r = Restaurant(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      name: _name.text.trim(),
      category: _cat!,
      area: _area,
      address: _addr.text.trim(),
      image: 'assets/images/resto_default.jpg',
      distanceKm: 1.5,
      rating: 0,
      reviews: 0,
      priceFrom: int.tryParse(_pf.text.trim()) ?? 0,
      priceTo: int.tryParse(_pt.text.trim()),
      tablesFree: _tables,
      specialty: _desc.text.trim().isEmpty ? _cat! : _desc.text.trim(),
      badge: 'Mitra Baru',
      tags: _fac.take(2).toList(),
      hours: '${_fmt(_open)} - ${_fmt(_close)} WIT',
      whatsapp: _wa.text.trim(),
      totalTables: _tables,
      seatsPerTable: _seats,
      openTime: _fmt(_open),
      closeTime: _fmt(_close),
      openDays: _allDays.where(_days.contains).toList(),
      facilities: [..._fac, ..._type],
      ownerName: auth.user?.name ?? '',
      description: _desc.text.trim(),
      status: isAdministrator ? RestaurantStatus.approved : RestaurantStatus.pending,
    );
    // Backend: POST /api/restaurants
    context.read<RestaurantProvider>().addRestaurant(r);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Warung Terdaftar'),
        content: Text(isAdministrator
            ? '${r.name} langsung aktif dan tampil di aplikasi.'
            : '${r.name} berhasil dikirim. Warung akan tampil setelah disetujui Administrator.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('OK')),
        ],
      ),
    );
  }
 
  Widget _sec(IconData i, String t) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 10),
        child: Row(children: [
          Icon(i, color: AppColors.primaryDark, size: 20),
          gapW(8),
          Text(t, style: ts(16, w: FontWeight.w800)),
        ]),
      );
 
  Widget _lbl(String t) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(t, style: ts(13, w: FontWeight.w700)),
      );
 
  Widget _stepper(String label, String sub, int v, ValueChanged<int> on) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: box(color: AppColors.surface, r: 16),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: ts(14, w: FontWeight.w800)),
              Text(sub, style: ts(11, c: AppColors.muted)),
            ]),
          ),
          IconButton(
              onPressed: v > 1 ? () => on(v - 1) : null,
              style: IconButton.styleFrom(backgroundColor: Colors.white),
              icon: const Icon(Icons.remove_rounded)),
          SizedBox(
              width: 34,
              child: Text('$v',
                  textAlign: TextAlign.center,
                  style: ts(18, w: FontWeight.w800, c: AppColors.primaryDark))),
          IconButton(
              onPressed: v < 200 ? () => on(v + 1) : null,
              style: IconButton.styleFrom(backgroundColor: AppColors.primary),
              icon: const Icon(Icons.add_rounded, color: Colors.white)),
        ]),
      );
 
  Widget _timeBox(String label, TimeOfDay t, bool isOpen) => Expanded(
        child: GestureDetector(
          onTap: () => _pickTime(isOpen),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: box(color: AppColors.surface, r: 16),
            child: Row(children: [
              const Icon(Icons.schedule_rounded, color: AppColors.primaryDark),
              gapW(10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: ts(11, c: AppColors.muted)),
                Text('${_fmt(t)} WIT', style: ts(15, w: FontWeight.w800)),
              ]),
            ]),
          ),
        ),
      );
 
  String? _req(String? v, String l) => (v ?? '').trim().isEmpty ? '$l wajib diisi' : null;
 
  @override
  Widget build(BuildContext context) {
    final cats = context.watch<SystemProvider>().categories;
    final isAdministrator = context.read<AuthProvider>().user?.role == AppRole.administrator;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Tambah Warung Baru', style: ts(18, w: FontWeight.w800)),
      ),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 30), children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: box(color: AppColors.amberSoft, r: 14),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primaryDark),
              gapW(10),
              Expanded(
                  child: Text(
                      isAdministrator
                          ? 'Sebagai Administrator, warung yang Anda tambahkan langsung aktif.'
                          : 'Warung baru akan diperiksa Administrator sebelum tampil ke pelanggan.',
                      style: ts(12, h: 1.4))),
            ]),
          ),
          _sec(Icons.storefront_rounded, 'Informasi Dasar'),
          _lbl('Nama Warung / Restoran'),
          TextFormField(
              controller: _name,
              decoration: const InputDecoration(hintText: 'Contoh: Warung Gohu Mama Etha'),
              validator: (v) => _req(v, 'Nama warung')),
          _lbl('Kategori Masakan'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final c in cats)
              FilterPill(label: c, selected: _cat == c, selBg: AppColors.primary, onTap: () => setState(() => _cat = c)),
          ]),
          _lbl('Wilayah'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final a in _areas)
              FilterPill(label: a, selected: _area == a, selBg: AppColors.primary, onTap: () => setState(() => _area = a)),
          ]),
          _lbl('Alamat Lengkap'),
          TextFormField(
              controller: _addr,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Jl. ..., Kelurahan ..., Ternate'),
              validator: (v) => _req(v, 'Alamat')),
          _lbl('Nomor WhatsApp Warung'),
          TextFormField(
              controller: _wa,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: '+62 812-0000-0000'),
              validator: (v) => _req(v, 'Nomor WhatsApp')),
          _lbl('Deskripsi / Menu Andalan'),
          TextFormField(
              controller: _desc,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Ceritakan menu andalan dan suasana warung')),
 
          _sec(Icons.table_restaurant_rounded, 'Meja & Kapasitas'),
          _stepper('Jumlah Meja', 'Total meja yang bisa direservasi', _tables, (v) => setState(() => _tables = v)),
          gap(8),
          _stepper('Kursi per Meja', 'Rata-rata kursi di setiap meja', _seats, (v) => setState(() => _seats = v)),
          gap(8),
          Text('Total kapasitas: ${_tables * _seats} kursi',
              style: ts(12, w: FontWeight.w800, c: AppColors.green)),
          _lbl('Jenis Meja'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in _types)
              FilterPill(
                  label: t,
                  selected: _type.contains(t),
                  selBg: AppColors.green,
                  onTap: () => setState(() => _type.contains(t) ? _type.remove(t) : _type.add(t))),
          ]),
 
          _sec(Icons.schedule_rounded, 'Jam & Hari Operasional'),
          Row(children: [_timeBox('Jam Buka', _open, true), gapW(10), _timeBox('Jam Tutup', _close, false)]),
          _lbl('Hari Buka'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final d in _allDays)
              FilterPill(
                  label: d,
                  selected: _days.contains(d),
                  selBg: AppColors.primary,
                  onTap: () => setState(() => _days.contains(d) ? _days.remove(d) : _days.add(d))),
          ]),
 
          _sec(Icons.payments_outlined, 'Harga & Fasilitas'),
          Row(children: [
            Expanded(
              child: TextFormField(
                  controller: _pf,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Harga mulai (Rp)'),
                  validator: (v) => int.tryParse((v ?? '').trim()) == null ? 'Isi angka' : null),
            ),
            gapW(10),
            Expanded(
              child: TextFormField(
                  controller: _pt,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Harga sampai (Rp)')),
            ),
          ]),
          _lbl('Fasilitas'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final f in _facilities)
              FilterPill(
                  label: f,
                  selected: _fac.contains(f),
                  selBg: AppColors.green,
                  onTap: () => setState(() => _fac.contains(f) ? _fac.remove(f) : _fac.add(f))),
          ]),
 
          _sec(Icons.photo_camera_outlined, 'Foto Warung'),
          GestureDetector(
            onTap: () => toast(context, 'Unggah foto akan tersambung ke backend'),
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryDark, size: 28),
                gap(6),
                Text('Ketuk untuk memilih foto', style: ts(12, c: AppColors.muted)),
              ]),
            ),
          ),
          gap(14),
          Row(children: [
            Checkbox(
                value: _agree,
                activeColor: AppColors.green,
                onChanged: (v) => setState(() => _agree = v ?? false)),
            Expanded(child: Text('Saya menyetujui Syarat Mitra MakanKuy.', style: ts(12, c: AppColors.muted))),
          ]),
          gap(10),
          PrimaryButton(label: 'Daftarkan Warung', icon: Icons.check_rounded, onPressed: _submit),
        ]),
      ),
    );
  }
}