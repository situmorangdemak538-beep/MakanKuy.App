import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // --- HEADER MERCHANT ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'MakanKuy Partner ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'UMKM',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: const [
                          Icon(Icons.circle, color: Colors.green, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'RM Gohu Ikan Gamalama • Buka',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- BUKA OPERASIONAL BANNER ---
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10),
                        SizedBox(width: 6),
                        Text(
                          'BUKA OPERASIONAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '10:00 - 22:00 WIT',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- RINGKASAN HARI INI ---
              const Text(
                'Ringkasan Hari Ini',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Jl. Pahlawan Revolusi, Ternate Tengah • Gamalama',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 16),

              // --- GRID STATISTIK ---
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  // Total Reservasi
                  _buildStatCard(
                    icon: Icons.calendar_today_outlined,
                    iconColor: Colors.orange,
                    badgeText: '+4',
                    badgeColor: Colors.green.shade100,
                    badgeTextColor: Colors.green,
                    title: 'Total Reservasi',
                    value: '18 Booking',
                    subtitle: 'Naik dibanding kemarin',
                  ),
                  // Okupansi Meja
                  _buildStatCard(
                    icon: Icons.chair_outlined,
                    iconColor: Colors.orange,
                    badgeText: '80%',
                    badgeColor: Colors.orange.shade100,
                    badgeTextColor: Colors.orange,
                    title: 'Okupansi Meja',
                    value: '8 / 10 Meja',
                    subtitle: '',
                    showProgressBar: true,
                  ),
                  // Estimasi Omzet
                  _buildStatCard(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Colors.teal,
                    badgeText: 'Pre-order',
                    badgeColor: Colors.grey.shade200,
                    badgeTextColor: Colors.black54,
                    title: 'Estimasi Omzet',
                    value: 'Rp 1.850.000',
                    subtitle: '14 reservasi santap',
                  ),
                  // Butuh Tindakan
                  _buildStatCard(
                    icon: Icons.notifications_active,
                    iconColor: Colors.white,
                    iconBgColor: Colors.red,
                    title: 'Butuh Tindakan',
                    value: '3 Reservasi',
                    subtitle: 'Perlu respon segera',
                    valueColor: Colors.red,
                    cardBgColor: Colors.red.shade50,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- TOMBOL AKSI CEPAT ---
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Scan Tamu Tiba',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5722),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.teal,
                      ),
                      label: const Text(
                        'Reservasi Buka',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- DENAH & STATUS MEJA HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Denah & Status Meja',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua (10)',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),

              // Keterangan Status
              Row(
                children: [
                  _buildLegend(Colors.green, 'Tersedia'),
                  const SizedBox(width: 12),
                  _buildLegend(Colors.red, 'Terisi'),
                  const SizedBox(width: 12),
                  _buildLegend(Colors.orange, 'Booking'),
                  const Spacer(),
                  const Text(
                    'Live Monitor',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- GRID MEJA ---
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildTableCard(
                    name: 'Meja 01',
                    status: 'Terisi',
                    statusColor: Colors.orange.shade800,
                    statusBgColor: Colors.orange.shade100,
                    accentColor: Colors.orange,
                    desc: 'Indoor AC • 4 Kursi',
                    note: 'Makan di tempat',
                  ),
                  _buildTableCard(
                    name: 'Meja 02',
                    status: 'Kosong',
                    statusColor: Colors.green,
                    statusBgColor: Colors.green.shade100,
                    accentColor: Colors.green,
                    desc: 'Indoor AC • 4 Kursi',
                    note: 'Siap ditempati',
                  ),
                  _buildTableCard(
                    name: 'Meja 06',
                    status: '19:00 WIT',
                    statusColor: Colors.orange.shade800,
                    statusBgColor: Colors.orange.shade100,
                    accentColor: Colors.orange,
                    desc: 'Lesehan Laut • 6 Kursi',
                    note: 'Farhan A. (4 Tamu)',
                  ),
                  _buildTableCard(
                    name: 'Gazebo Ke...',
                    status: 'Kosong',
                    statusColor: Colors.green,
                    statusBgColor: Colors.green.shade100,
                    accentColor: Colors.green,
                    desc: 'Outdoor Teduh • 4 Kursi',
                    note: 'Booking 18:30 nanti',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Card Statistik
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    Color? iconBgColor,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
    required String title,
    required String value,
    required String subtitle,
    Color? valueColor,
    Color? cardBgColor,
    bool showProgressBar = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBgColor ?? iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconBgColor != null ? Colors.white : iconColor,
                  size: 20,
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87,
                ),
              ),
              if (showProgressBar) ...[
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.8,
                    backgroundColor: Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    minHeight: 4,
                  ),
                ),
              ],
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget Keterangan Warna Status
  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 8),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // Helper Widget Card Status Meja
  Widget _buildTableCard({
    required String name,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required Color accentColor,
    required String desc,
    required String note,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
            note,
            style: const TextStyle(fontSize: 10, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
