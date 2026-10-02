import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../utils/colors.dart';

class MenuCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.menu,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fastfood,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menu.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rp ${menu.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
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