import 'package:flutter/material.dart';

class AdminStoreScreen extends StatelessWidget {
  const AdminStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('MK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('MakanKuy Partner ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
                      child: const Text('UMKM', style: TextStyle(color: Colors.deepOrange, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Text('• RM Gohu Ikan Gamalama • Buka', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Profil Toko', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          
          // Card Info Toko
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.storefront, 'Nama', 'RM Gohu Ikan Gamalama'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on_outlined, 'Alamat', 'Jl. Pahlawan Revolusi No. 42, Ternate Tengah'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time, 'Jam Buka', '10:00 - 22:00 WIT (Setiap Hari)'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.chat_outlined, 'WhatsApp', '+62 812-4421-9870'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.person_outline, 'Pengelola', 'Farhan Abdurrahman'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Edit
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Text('Edit Data Restoran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),

          // Tombol Logout -> Kembali Penuh ke Customer Mode
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                // Menutup antarmuka Admin dan kembali ke antarmuka Customer
                Navigator.of(context, rootNavigator: true).pop();
              },
              icon: const Icon(Icons.logout, color: Colors.red, size: 18),
              label: const Text('Keluar dari Akun (Logout)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.deepOrange),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
        ),
      ],
    );
  }
}