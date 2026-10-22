import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/admin_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/system_provider.dart';
 
/// Kelola kategori masakan secara terpusat (dipakai di form Tambah Warung).
class AdministratorCategoriesScreen extends StatelessWidget {
  const AdministratorCategoriesScreen({super.key});
 
  Future<void> _dialog(BuildContext context, {int? index}) async {
    final sp = context.read<SystemProvider>();
    final ctrl = TextEditingController(text: index == null ? '' : sp.categories[index]);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(index == null ? 'Tambah Kategori' : 'Ubah Kategori'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(hintText: 'Nama kategori')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Simpan')),
        ],
      ),
    );
    if (ok != true) return;
    if (index == null) {
      sp.addCategory(ctrl.text);
    } else {
      sp.renameCategory(index, ctrl.text);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SystemProvider>();
    return Scaffold(
      backgroundColor: AdminColors.bg,
      appBar: AppBar(
        backgroundColor: AdminColors.navy,
        foregroundColor: Colors.white,
        title: Text('Kategori Masakan', style: ts(17, w: FontWeight.w800, c: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialog(context),
        backgroundColor: AdminColors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('Tambah', style: ts(14, w: FontWeight.w800, c: Colors.white)),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 90), children: [
        for (var i = 0; i < sp.categories.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: box(color: Colors.white, r: 14),
            child: Row(children: [
              const Icon(Icons.category_rounded, color: AdminColors.indigo),
              gapW(12),
              Expanded(child: Text(sp.categories[i], style: ts(14, w: FontWeight.w800))),
              IconButton(
                  onPressed: () => _dialog(context, index: i),
                  icon: const Icon(Icons.edit_outlined, size: 20, color: AdminColors.indigo)),
              IconButton(
                  onPressed: () => sp.removeCategory(i),
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.red)),
            ]),
          ),
      ]),
    );
  }
}