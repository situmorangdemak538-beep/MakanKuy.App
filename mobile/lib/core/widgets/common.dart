import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Widget gap(double h) => SizedBox(height: h);
Widget gapW(double w) => SizedBox(width: w);

TextStyle ts(double size,
        {FontWeight w = FontWeight.w500, Color? c, double? h}) =>
    TextStyle(
        fontSize: size, fontWeight: w, color: c ?? AppColors.ink, height: h);

void toast(BuildContext c, String m) {
  ScaffoldMessenger.of(c).showSnackBar(
    SnackBar(content: Text(m), behavior: SnackBarBehavior.floating),
  );
}

BoxDecoration box({Color color = Colors.white, double r = 20, Color? border}) =>
    BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(r),
      border: border == null ? null : Border.all(color: border),
    );

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withAlpha(70),
              blurRadius: size * 0.25,
              offset: Offset(0, size * 0.1)),
        ],
      ),
      child: Icon(Icons.room_service_rounded,
          color: Colors.white, size: size * 0.58),
    );
  }
}

class FoodImage extends StatelessWidget {
  final String? path;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  const FoodImage(
      {super.key,
      this.path,
      this.width,
      this.height,
      this.radius = 16,
      this.fit = BoxFit.cover});

  Widget get _placeholder => Container(
        color: const Color(0xFFE2C3AE),
        alignment: Alignment.center,
        child: const Icon(Icons.restaurant, color: Colors.white70, size: 30),
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: path == null
            ? _placeholder
            : Image.asset(path!,
                fit: fit, errorBuilder: (_, __, ___) => _placeholder),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  const Avatar({super.key, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset('assets/images/avatar.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                  color: AppColors.peach,
                  child: Icon(Icons.person,
                      color: AppColors.primaryDark, size: size * 0.6),
                )),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  final IconData? icon;
  final double fontSize;
  const Pill(
      {super.key,
      required this.text,
      this.bg = AppColors.surface,
      this.fg = AppColors.ink,
      this.icon,
      this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: fontSize + 3, color: fg),
          gapW(4),
        ],
        Flexible(
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              style: ts(fontSize, w: FontWeight.w700, c: fg)),
        ),
      ]),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final double height;
  const PrimaryButton(
      {super.key,
      required this.label,
      this.onPressed,
      this.icon,
      this.color = AppColors.primary,
      this.height = 54});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: color.withAlpha(90),
          shape: const StadiumBorder(),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: ts(16, w: FontWeight.w800, c: Colors.white))),
          if (icon != null) ...[gapW(8), Icon(icon, size: 18)],
        ]),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle, action;
  final VoidCallback? onAction;
  final IconData? trailingIcon;
  const SectionTitle(
      {super.key,
      required this.title,
      this.subtitle,
      this.action,
      this.onAction,
      this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: ts(17, w: FontWeight.w800)),
          if (subtitle != null)
            Text(subtitle!, style: ts(12, c: AppColors.muted)),
        ]),
      ),
      if (action != null)
        GestureDetector(
          onTap: onAction,
          child: Text(action!,
              style: ts(13, w: FontWeight.w800, c: AppColors.primaryDark)),
        ),
      if (trailingIcon != null)
        Icon(trailingIcon, color: AppColors.primaryDark),
    ]);
  }
}

class FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color selBg, selFg;
  const FilterPill(
      {super.key,
      required this.label,
      this.selected = false,
      this.onTap,
      this.icon,
      this.selBg = AppColors.primaryDark,
      this.selFg = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? selBg : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: selected ? selBg : AppColors.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: selected ? selFg : AppColors.muted),
            gapW(6),
          ],
          Text(label,
              style: ts(13,
                  w: FontWeight.w700,
                  c: selected ? selFg : AppColors.ink)),
        ]),
      ),
    );
  }
}

/// Header customer: logo + judul + lonceng + avatar
class BrandHeader extends StatelessWidget {
  final String title;
  final String? eyebrow, subtitle;
  const BrandHeader(
      {super.key, required this.title, this.eyebrow, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 6),
        child: Row(children: [
          const AppLogo(size: 40),
          gapW(10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eyebrow != null)
                    Text(eyebrow!,
                        style: ts(10,
                            w: FontWeight.w800, c: AppColors.primaryDark)),
                  Text(title, style: ts(18, w: FontWeight.w800)),
                  if (subtitle != null)
                    Text(subtitle!, style: ts(12, c: AppColors.muted)),
                ]),
          ),
          IconButton(
              onPressed: () => toast(context, 'Belum ada notifikasi baru'),
              icon: const Icon(Icons.notifications_none_rounded)),
          const Avatar(size: 38),
        ]),
      ),
    );
  }
}

/// Top bar halaman detail: back, logo, judul, share, bookmark, avatar
class DetailTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onShare;
  const DetailTopBar({super.key, required this.title, this.onShare});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
        child: Row(children: [
          IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_rounded)),
          const AppLogo(size: 32),
          gapW(8),
          Expanded(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: ts(17, w: FontWeight.w800))),
          IconButton(
              onPressed: onShare, icon: const Icon(Icons.share_outlined)),
          IconButton(
              onPressed: () => toast(context, 'Disimpan ke favorit'),
              icon: const Icon(Icons.bookmark_border_rounded)),
          const Avatar(size: 34),
        ]),
      ),
    );
  }
}

class NavItemData {
  final IconData icon;
  final String label;
  final int badge;
  const NavItemData(this.icon, this.label, {this.badge = 0});
}

class AppBottomNav extends StatelessWidget {
  final List<NavItemData> items;
  final int index;
  final ValueChanged<int> onTap;
  const AppBottomNav(
      {super.key,
      required this.items,
      required this.index,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final it = items[i];
              final active = i == index;
              final color = active ? AppColors.primary : AppColors.muted;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Badge(
                        isLabelVisible: it.badge > 0,
                        label: Text('${it.badge}'),
                        child: Icon(it.icon, color: color, size: 26),
                      ),
                      gap(3),
                      Text(it.label,
                          style: ts(11, w: FontWeight.w700, c: color)),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}