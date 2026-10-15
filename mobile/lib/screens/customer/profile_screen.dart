import 'package:flutter/material.dart';
fitur/tegar
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../data/dummy_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../partner/register_restaurant_screen.dart';
import 'restaurant_detail_screen.dart';
 


main
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
 
class _ProfileScreenState extends State<ProfileScreen> {
fitur/tegar
  bool _reminder = true;
 
  Widget _stat(IconData i, Color bg, String v, String l) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: box(color: AppColors.surface, r: 20),
          child: Column(children: [

  // Status pengingat WhatsApp.
  bool _whatsappNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // Header halaman profil pengguna.
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2F0),
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            main
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'MK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Profil Pengguna',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
fitur/tegar
      );
 
  Widget _menuRow(IconData i, String t, String sub, VoidCallback onTap,
      {bool highlight = false, String? tag}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: box(color: highlight ? Colors.white : Colors.transparent, r: 16),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: highlight ? AppColors.peach : AppColors.surface, shape: BoxShape.circle),
            child: Icon(i, size: 20, color: highlight ? AppColors.primaryDark : AppColors.muted),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black87,
              size: 22,
            ),
            onPressed: () {
              _showMessage('Fitur notifikasi');
            },
main
          ),
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: Colors.black87,
              size: 22,
            ),
            onPressed: () {
              _showMessage('Kamu sedang berada di halaman profil');
            },
          ),
        ],
      ),
fitur/tegar
    );
  }
 
  void _edit(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final name = TextEditingController(text: auth.user?.name);
    final phone = TextEditingController(text: auth.user?.phone);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Edit Profil', style: ts(18, w: FontWeight.w800)),
          gap(14),
          TextField(controller: name, decoration: const InputDecoration(hintText: 'Nama lengkap')),
          gap(10),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: 'Nomor WhatsApp')),
          gap(16),
          PrimaryButton(
              label: 'Simpan',
              onPressed: () {
                auth.updateProfile(name.text.trim(), phone.text.trim());
                Navigator.pop(ctx);
              }),
        ]),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final rp = context.watch<RestaurantProvider>();
    final res = context.watch<ReservationProvider>();
    final favs = rp.all.where((r) => rp.saved.contains(r.id)).toList();
    final doneCount = res.mine.where((r) => r.status.name == 'completed').length + 12;
 
    return Scaffold(
      body: Column(children: [
        const BrandHeader(eyebrow: 'MAKANKUY TERNATE', title: 'Profil Pengguna'),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: box(color: AppColors.surface, r: 26),
              child: Column(children: [
                Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                    child: const Avatar(size: 92),

      // Isi profil pengguna.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. INFORMASI PROFIL PENGGUNA
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.deepOrange,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Farhan Abdurrahman',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on, size: 13, color: Colors.grey),
                    SizedBox(width: 2),
                    Text(
                      'Gamalama, Ternate Tengah',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        size: 12,
                        color: Colors.amber.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Penjelajah Kuliner Ternate • Level 3',
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+62 812-4421-9870 • salwa@gmail.com',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    _showMessage('Fitur edit profil belum diaktifkan');
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: Colors.black87,
                  ),
                  label: const Text(
                    'Edit Profil',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. STATISTIK PENGGUNA
          Row(
            children: [
              _buildStatBox(
                '14',
                'Reservasi\nSukses',
                Icons.calendar_today_outlined,
              ),
              const SizedBox(width: 10),
              _buildStatBox(
                '2',
                'Resto\nDisimpan',
                Icons.bookmark_border_rounded,
              ),
              const SizedBox(width: 10),
              _buildStatBox(
                '15',
                'Ulasan\nKuliner',
                Icons.rate_review_outlined,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 3. RESTORAN FAVORIT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 16,
                    color: Colors.deepOrange,
main
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Restoran Ternate Favorit',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  _showMessage('Daftar restoran favorit');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text(
                  'Lihat Semua (2)',
                  style: TextStyle(fontSize: 11, color: Colors.deepOrange),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFavCard(
                  'Rumah Makan Gohu Ikan Gamalama',
                  'Ternate Tengah • Kuliner Khas Gamalama',
                  '4.9',
                  '4 Meja Siap',
                ),
                const SizedBox(width: 10),
                _buildFavCard(
                  'Dapur Ikan Fufu Dodoku Ali',
                  'Ternate Selatan • Seafood Bakar',
                  '4.8',
                  '5 Meja Siap',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. PREFERENSI KULINER DAN RESERVASI
          Row(
            children: const [
              Icon(Icons.tune_rounded, size: 16, color: Colors.deepOrange),
              SizedBox(width: 6),
              Text(
                'Preferensi Kuliner & Reservasi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          const Text(
            'Suasana & Menu Favorit',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag('Gohu Ikan'),
              _buildTag('Ikan Fufu'),
              _buildTag('Seafood Bakar'),
              _buildTag('Kopi Guraka'),
            ],
          ),

          const SizedBox(height: 12),

          // Kartu pengaturan preferensi pengguna.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Pengingat WhatsApp.
                Row(
                  children: [
                    const Icon(
                      Icons.chat_outlined,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengingat WhatsApp',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Kirim konfirmasi H-1 jam reservasi via WA',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _whatsappNotification,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _whatsappNotification = value;
                        });
                      },
                    ),
                  ],
                ),

                const Divider(height: 16),

                // Wilayah prioritas pengguna.
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wilayah Prioritas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Ternate Tengah & Ternate Selatan',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showMessage('Fitur ubah wilayah belum diaktifkan');
                      },
                      child: const Text(
                        'Ubah',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 5. PENGATURAN DAN BANTUAN
          const Text(
            'Pengaturan & Bantuan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Hanya pengaturan milik pengguna.
          // Menu Admin Restoran tidak ditempatkan di sini.
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.notifications_none,
                    size: 20,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Metode Notifikasi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    'WhatsApp & Push App',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _showMessage('Pengaturan metode notifikasi');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Menampilkan pesan sederhana.
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
  }

  // Widget statistik pengguna.
  Widget _buildStatBox(String count, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
fitur/tegar
              padding: const EdgeInsets.all(12),
              decoration: box(color: AppColors.surface, r: 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
                  child: Text('Pengaturan & Bantuan', style: ts(16, w: FontWeight.w800)),
                ),
                _menuRow(Icons.notifications_none_rounded, 'Metode Notifikasi', 'WhatsApp & Push App', () => toast(context, 'Segera hadir')),
                _menuRow(Icons.storefront_rounded, 'Daftarkan Warung/Resto Anda', 'Gabung Komunitas Mitra Kuliner MakanKuy', () => openRegisterRestaurant(context), highlight: true, tag: 'GRATIS'),
                _menuRow(Icons.support_agent_rounded, 'Pusat Bantuan & Komunitas', 'Bantuan pesan meja & tanya foodie Ternate', () => toast(context, 'Segera hadir')),
                _menuRow(Icons.shield_outlined, 'Syarat & Kebijakan Privasi', 'Informasi penggunaan data & keamanan', () => toast(context, 'Segera hadir')),
              ]),

              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.deepOrange, size: 16),
main
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kartu restoran favorit.
  Widget _buildFavCard(
    String title,
    String subtitle,
    String rating,
    String status,
  ) {
    return Container(
      width: 264,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.restaurant, color: Colors.orange, size: 32),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 10),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Buka',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.bookmark,
                      size: 14,
                      color: Colors.deepOrange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget tag preferensi kuliner.
  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant_menu, size: 10, color: Colors.deepOrange),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.deepOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
