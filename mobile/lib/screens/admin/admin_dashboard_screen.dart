import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const Color _background = Color(0xFFF8F9FA);
  static const Color _primary = Colors.deepOrange;
  static const Color _textPrimary = Color(0xFF212121);
  static const Color _textSecondary = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0.5,
        centerTitle: false,
        titleSpacing: 16,
        toolbarHeight: 76,
        title: Row(
          children: [
            // Logo MakanKuy.
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text(
                'MK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Informasi restoran.
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      const Text(
                        'MakanKuy Partner',
                        style: TextStyle(
                          color: _textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8D9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'UMKM',
                          style: TextStyle(
                            color: _primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 8,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'RM Gohu Ikan Gamalama • Buka',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Hari Ini',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Pantau aktivitas restoran kamu hari ini.',
                style: TextStyle(
                  fontSize: 13,
                  color: _textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              // Grid statistik yang menyesuaikan lebar layar.
              LayoutBuilder(
                builder: (context, constraints) {
                  final int columns = constraints.maxWidth >= 600 ? 4 : 2;

                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: columns == 4 ? 1.15 : 1.5,
                    children: const [
                      _SummaryCard(
                        title: 'Reservasi',
                        value: '12',
                        subtitle: 'Hari ini',
                        icon: Icons.phone_android_rounded,
                        iconColor: Colors.blue,
                        iconBackground: Color(0xFFE3F2FD),
                      ),
                      _SummaryCard(
                        title: 'Pendapatan',
                        value: 'Rp 850k',
                        subtitle: 'Hari ini',
                        icon: Icons.account_balance_wallet_rounded,
                        iconColor: Colors.green,
                        iconBackground: Color(0xFFE8F5E9),
                      ),
                      _SummaryCard(
                        title: 'Meja Terisi',
                        value: '4/10',
                        subtitle: 'Meja digunakan',
                        icon: Icons.table_restaurant_rounded,
                        iconColor: Color(0xFFFFA000),
                        iconBackground: Color(0xFFFFF3E0),
                      ),
                      _SummaryCard(
                        title: 'Menu Aktif',
                        value: '24',
                        subtitle: 'Menu tersedia',
                        icon: Icons.restaurant_menu_rounded,
                        iconColor: Colors.purple,
                        iconBackground: Color(0xFFF3E5F5),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Bagian aktivitas.
              const Text(
                'Aktivitas Restoran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEEEEEE),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: _primary,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang di MakanKuy Partner',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _textPrimary,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Kelola menu dan pantau reservasi '
                            'restoran melalui dashboard ini.',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 19,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
