import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/admin_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../data/models/user_profile.dart';
import '../../providers/system_provider.dart';
import 'administrator_shell.dart';
 
/// Kelola seluruh pengguna (customer & admin restoran): cari, filter peran, blokir/aktifkan.
class AdministratorUsersScreen extends StatefulWidget {
  const AdministratorUsersScreen({super.key});
  @override
  State<AdministratorUsersScreen> createState() => _AdministratorUsersScreenState();
}
 
class _AdministratorUsersScreenState extends State<AdministratorUsersScreen> {
  String _q = '';
  AppRole? _role;
 
  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SystemProvider>();
    final list = sp.users.where((u) {
      final okQ = _q.isEmpty ||
          u.name.toLowerCase().contains(_q.toLowerCase()) ||
          u.email.toLowerCase().contains(_q.toLowerCase());
      final okR = _role == null || u.role == _role;
      return okQ && okR;
    }).toList();
 
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: Column(children: [
        const AdministratorHeader(
            title: 'Kelola Pengguna', subtitle: 'Blokir atau aktifkan akun pengguna'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            decoration: const InputDecoration(
                hintText: 'Cari nama atau email...', prefixIcon: Icon(Icons.search_rounded)),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            FilterPill(label: 'Semua (${sp.users.length})', selected: _role == null, selBg: AdminColors.indigo, onTap: () => setState(() => _role = null)),
            gapW(8),
            FilterPill(label: 'Customer (${sp.countRole(AppRole.customer)})', selected: _role == AppRole.customer, selBg: AdminColors.indigo, onTap: () => setState(() => _role = AppRole.customer)),
            gapW(8),
            FilterPill(label: 'Admin Restoran (${sp.countRole(AppRole.admin)})', selected: _role == AppRole.admin, selBg: AdminColors.indigo, onTap: () => setState(() => _role = AppRole.admin)),
          ]),
        ),
        gap(8),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 20), children: [
            for (final u in list)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: box(color: Colors.white, r: 16),
                child: Row(children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: u.blocked ? AppColors.redSoft : AdminColors.indigoSoft,
                    child: Text(u.name.isEmpty ? '?' : u.name[0],
                        style: ts(15, w: FontWeight.w800, c: u.blocked ? AppColors.red : AdminColors.indigo)),
                  ),
                  gapW(12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(u.name, style: ts(14, w: FontWeight.w800)),
                      Text(u.email, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(11, c: AppColors.muted)),
                      gap(4),
                      Row(children: [
                        Pill(
                            text: u.role.label,
                            bg: u.role == AppRole.admin ? AppColors.amberSoft : AdminColors.indigoSoft,
                            fg: u.role == AppRole.admin ? const Color(0xFF6B4400) : AdminColors.indigo,
                            fontSize: 9),
                        gapW(6),
                        if (u.blocked)
                          const Pill(text: 'Diblokir', bg: AppColors.redSoft, fg: AppColors.red, fontSize: 9),
                      ]),
                    ]),
                  ),
                  TextButton(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(u.blocked ? 'Aktifkan akun?' : 'Blokir akun?'),
                          content: Text(u.blocked
                              ? '${u.name} dapat masuk kembali.'
                              : '${u.name} tidak akan bisa masuk ke aplikasi.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ya')),
                          ],
                        ),
                      );
                      if (ok == true) sp.toggleBlock(u); // Backend: PUT /api/users/{id}/block
                    },
                    child: Text(u.blocked ? 'Aktifkan' : 'Blokir',
                        style: ts(12, w: FontWeight.w800, c: u.blocked ? AppColors.green : AppColors.red)),
                  ),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }
}