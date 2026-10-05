import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/auth_provider.dart';
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

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    await auth.login(_email.text, _pass.text);
    if (!mounted) return;
    goHome(context, auth.user!.role);
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().loading;
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
                    decoration: const BoxDecoration(
                        color: AppColors.surface, shape: BoxShape.circle),
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
                const AppLogo(size: 80),
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: AppColors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.restaurant,
                        color: Colors.white, size: 16),
                  ),
                ),
              ]),
              gap(20),
              Text('Selamat Datang Kembali!',
                  style: ts(26, w: FontWeight.w800)),
              gap(6),
              Text('Masuk untuk pesan meja di restoran\nfavoritmu di Ternate.',
                  textAlign: TextAlign.center,
                  style: ts(14, c: AppColors.muted, h: 1.5)),
              gap(22),
              InkWell(
                onTap: () => toast(context, 'Login Google segera hadir'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(18),
                          blurRadius: 12,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('G',
                        style: ts(24,
                            w: FontWeight.w800,
                            c: const Color(0xFF4285F4))),
                    gapW(12),
                    Text('Masuk dengan Google', style: ts(15, w: FontWeight.w800)),
                  ]),
                ),
              ),
              gap(18),
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('atau masuk dengan email',
                      style: ts(11, c: AppColors.muted)),
                ),
                const Expanded(child: Divider()),
              ]),
              gap(14),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Alamat Email', style: ts(13, w: FontWeight.w700))),
              gap(8),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'nama@domain.com',
                    prefixIcon: Icon(Icons.mail_outline_rounded)),
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
                    icon: Icon(_hide
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) => (v ?? '').length < 6
                    ? 'Kata sandi minimal 6 karakter'
                    : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => toast(context, 'Fitur lupa sandi segera hadir'),
                  child: Text('Lupa Kata Sandi?',
                      style: ts(12, w: FontWeight.w800, c: AppColors.primaryDark)),
                ),
              ),
              PrimaryButton(
                label: loading ? 'Memproses...' : 'Masuk Sekarang',
                icon: loading ? null : Icons.arrow_forward_rounded,
                onPressed: loading ? null : _submit,
              ),
              gap(18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: box(color: AppColors.surface, r: 18),
                child: Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppColors.greenSoft,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.storefront_rounded,
                        color: AppColors.green),
                  ),
                  gapW(12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Makan Guraka & Ikan Fufu?',
                              style: ts(14, w: FontWeight.w800)),
                          Text('Cek ketersediaan meja 120+ resto lokal hari ini.',
                              style: ts(12, c: AppColors.muted)),
                        ]),
                  ),
                ]),
              ),
              gap(18),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Belum punya akun? ', style: ts(14, c: AppColors.muted)),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const RegisterScreen())),
                  child: Text('Daftar Sekarang',
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