import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:makankuy/models/menu_model.dart';
import 'package:makankuy/models/restaurant_model.dart';
import 'package:makankuy/providers/menu_provider.dart';
import 'package:makankuy/screens/menu_detail_screen.dart';
import 'package:makankuy/screens/reservation_form_screen.dart';
import 'package:makankuy/utils/colors.dart';
import 'package:makankuy/widgets/loading_widget.dart';
import 'package:makankuy/widgets/menu_card.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MenuProvider>().loadMenus(widget.restaurant.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menus = context.watch<MenuProvider>().menus;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.dark,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.cream,
                  child: const Icon(
                    Icons.restaurant,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.restaurant.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const Icon(Icons.star, color: AppColors.secondary),
                      const SizedBox(width: 3),
                      Text(
                        '${widget.restaurant.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _tag(widget.restaurant.category),
                      const SizedBox(width: 7),
                      _tag('Buka ${widget.restaurant.openingHours}'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _infoTile(
                    Icons.location_on_outlined,
                    widget.restaurant.address,
                    '${widget.restaurant.distance.toStringAsFixed(1)} km dari lokasi',
                  ),
                  const SizedBox(height: 9),
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.map_outlined,
                        color: AppColors.primary,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _stat(Icons.access_time, 'Jam Operasional',
                          widget.restaurant.openingHours),
                      _stat(Icons.payments_outlined, 'Harga Rata-rata',
                          'Rp${widget.restaurant.averagePrice ~/ 1000}k'),
                      _stat(Icons.location_on_outlined, 'Jarak',
                          '${widget.restaurant.distance} km'),
                    ],
                  ),
                  const SizedBox(height: 23),
                  const Text(
                    'Tentang Restoran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.restaurant.description,
                    maxLines: expanded ? null : 3,
                    overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => expanded = !expanded),
                    child: Text(expanded ? 'Sembunyikan' : 'Selengkapnya'),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Menu Populer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 215,
                    child: context.watch<MenuProvider>().loading
                        ? const LoadingWidget()
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: menus.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, index) {
                              final menu = menus[index];
                              return MenuCard(
                                menu: menu,
                                onTap: () => _openMenu(menu),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReservationFormScreen(
                            restaurant: widget.restaurant,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.event_available),
                      label: const Text(
                        'Reservasi Meja',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stat(IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 21),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  void _openMenu(MenuModel menu) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuDetailScreen(menu: menu),
      ),
    );
  }
}