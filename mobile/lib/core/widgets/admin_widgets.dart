import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'common.dart';

/// Kotak statistik (ikon, angka, label). Dipakai di dashboard & profil admin/administrator.
class StatBox extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const StatBox(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: box(color: Colors.white, r: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: color.withAlpha(35), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 19, color: color),
        ),
        const Spacer(),
        Text(value, style: ts(22, w: FontWeight.w800)),
        Text(label, style: ts(11, c: AppColors.muted)),
      ]),
    );
  }
}

/// Baris menu dengan ikon berwarna, judul, subjudul, dan panah.
class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final Color color;
  const ActionTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: box(color: Colors.white, r: 16),
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: color.withAlpha(35), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          gapW(12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: ts(14, w: FontWeight.w800)),
              Text(subtitle, style: ts(11, c: AppColors.muted)),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ]),
      ),
    );
  }
}