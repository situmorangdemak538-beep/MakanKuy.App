import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../data/models/user_profile.dart';
import '../../providers/auth_provider.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;
  AppRole _role = AppRole.customer;
 
  static const _roles = [
    (AppRole.customer, 'Customer', Icons.person_outline_rounded),
    (AppRole.admin, 'Admin Restoran', Icons.storefront_rounded),
    (AppRole.administrator, 'Administrator', Icons.shield_outlined),
  ];
 
  String get _hint => switch (_role) {
        AppRole.customer => 'Cari restoran & reservasi meja favoritmu di Ternate.',
        AppRole.admin => 'Kelola menu, reservasi, diskon, dan warung Anda.',
        AppRole.administrator => 'Panel pusat: persetujuan warung, pengguna, kategori, dan promo.',
      };
 
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }
 
  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    // Nanti: server memeriksa apakah akun ini benar-benar punya peran yang dipilih.
    await auth.login(_email.text, _pass.text, _role);
    if (!mounted) return;
    goHome(context, auth.user!.role);
  }
 
  Widget _roleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: box(color: AppColors.surface, r: 20),
      child: Row(
        children: _roles.map((r) {
          final sel = r.$1 == _role;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _role = r.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: [
                  Icon(r.$3, size: 20, color: sel ? Colors.white : AppColors.muted),
                  gap(2),
                  Text(r.$2,
                      textAlign: TextAlign.center,
                      style: ts(10, w: FontWeight.w800, c: sel ? Colors.white : AppColors.muted)),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().loading;
    final isCustomer = _role == AppRole.customer;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Form(
            key: _form,
            child: Column(children: [
              Row(children: [
                InkWell(
                  onTap: () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                const Spacer(),
                const Pill(
                    text: 'TERNATE, MALUKU UTARA',
                    bg: AppColors.amberSoft,
                    fg: AppColors.primaryDark,
                    icon: Icons.location_on_outlined),
              ]),
              gap(8),
              Stack(clipBehavior: Clip.none, children: [
                const AppLogo(size: 76),
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.restaurant, color: Colors.white, size: 16),
                  ),
                ),
              ]),
              gap(18),
              Text('Selamat Datang Kembali!', style: ts(25, w: FontWeight.w800)),
              gap(6),
              Text(_hint, textAlign: TextAlign.center, style: ts(13, c: AppColors.muted, h: 1.5)),
              gap(16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Masuk sebagai', style: ts(13, w: FontWeight.w700))),
              gap(8),
              _roleSelector(),
              gap(16),
              if (isCustomer) ...[
                InkWell(
                  onTap: () => toast(context, 'Login Google segera hadir'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(18), blurRadius: 12, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('G', style: ts(22, w: FontWeight.w800, c: const Color(0xFF4285F4))),
                      gapW(12),
                      Text('Masuk dengan Google', style: ts(15, w: FontWeight.w800)),
                    ]),
                  ),
                ),
                gap(14),
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('atau masuk dengan email', style: ts(11, c: AppColors.muted)),
                  ),
                  const Expanded(child: Divider()),
                ]),
                gap(14),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: box(color: AppColors.amberSoft, r: 14),
                  child: Row(children: [
                    const Icon(Icons.lock_person_outlined, color: AppColors.primaryDark),
                    gapW(10),
                    Expanded(
                        child: Text('Akses khusus. Peran akun diverifikasi oleh server sebelum masuk.',
                            style: ts(11, h: 1.4))),
                  ]),
                ),
                gap(14),
              ],
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Alamat Email', style: ts(13, w: FontWeight.w700))),
              gap(8),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'nama@domain.com', prefixIcon: Icon(Icons.mail_outline_rounded)),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return 'Email wajib diisi';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              gap(14),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Kata Sandi', style: ts(13, w: FontWeight.w700))),
              gap(8),
              TextFormField(
                controller: _pass,
                obscureText: _hide,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_hide ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) => (v ?? '').length < 6 ? 'Kata sandi minimal 6 karakter' : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                  child: Text('Lupa Kata Sandi?',
                      style: ts(12, w: FontWeight.w800, c: AppColors.primaryDark)),
                ),
              ),
              PrimaryButton(
                label: loading ? 'Memproses...' : 'Masuk sebagai ${_role.label}',
                icon: loading ? null : Icons.arrow_forward_rounded,
                onPressed: loading ? null : _submit,
              ),
              gap(18),
              if (_role != AppRole.administrator)
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(isCustomer ? 'Belum punya akun? ' : 'Ingin jadi mitra? ',
                      style: ts(14, c: AppColors.muted)),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: Text(isCustomer ? 'Daftar Sekarang' : 'Daftar Akun Dulu',
                        style: ts(14, w: FontWeight.w800, c: AppColors.primaryDark)),
                  ),
                ]),
            ]),
          ),
        ),
      ),
    );
  }
}