import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/auth_provider.dart';
 
/// Lupa kata sandi 3 langkah: (1) email  (2) kode verifikasi  (3) sandi baru.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
 
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  int _step = 0;
  bool _busy = false;
  bool _hide = true;
 
  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }
 
  static const _titles = ['Lupa Kata Sandi?', 'Masukkan Kode', 'Buat Sandi Baru'];
  static const _subs = [
    'Masukkan email akunmu. Kami akan mengirim kode verifikasi 6 digit.',
    'Cek email kamu lalu masukkan kode 6 digit yang kami kirim.',
    'Buat kata sandi baru yang kuat (minimal 8 karakter).',
  ];
 
  Future<void> _next() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    setState(() => _busy = true);
    var ok = true;
    if (_step == 0) {
      ok = await auth.requestReset(_email.text);
      if (ok && mounted) {
        toast(context, 'Kode dikirim ke email. (Demo: ${AuthProvider.demoResetCode})');
      }
    } else if (_step == 1) {
      ok = await auth.verifyCode(_email.text, _code.text);
      if (!ok && mounted) toast(context, 'Kode salah atau sudah kedaluwarsa');
    } else {
      ok = await auth.resetPassword(_email.text, _code.text, _p1.text);
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) return;
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Berhasil'),
        content: const Text('Kata sandi berhasil diubah. Silakan masuk dengan sandi baru.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Masuk')),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.pop(context);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _step > 0 && !_busy ? setState(() => _step--) : Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: List.generate(
                  3,
                  (i) => Expanded(
                        child: Container(
                          height: 5,
                          margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                          decoration: BoxDecoration(
                              color: i <= _step ? AppColors.primary : AppColors.border,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      )),
            ),
            gap(24),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(20)),
              child: Icon(
                  _step == 0 ? Icons.mail_lock_outlined : (_step == 1 ? Icons.pin_outlined : Icons.lock_reset_rounded),
                  size: 32,
                  color: AppColors.primaryDark),
            ),
            gap(16),
            Text(_titles[_step], style: ts(26, w: FontWeight.w800)),
            gap(6),
            Text(_subs[_step], style: ts(14, c: AppColors.muted, h: 1.5)),
            gap(22),
            if (_step == 0)
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'nama@domain.com', prefixIcon: Icon(Icons.mail_outline_rounded)),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return 'Email wajib diisi';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s)) return 'Format email tidak valid';
                  return null;
                },
              ),
            if (_step == 1)
              TextFormField(
                controller: _code,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: ts(24, w: FontWeight.w800),
                decoration: const InputDecoration(hintText: '••••••', counterText: ''),
                validator: (v) => (v ?? '').trim().length != 6 ? 'Kode harus 6 digit' : null,
              ),
            if (_step == 2) ...[
              TextFormField(
                controller: _p1,
                obscureText: _hide,
                decoration: InputDecoration(
                  hintText: 'Sandi baru (min. 8 karakter)',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_hide ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) => (v ?? '').length < 8 ? 'Minimal 8 karakter' : null,
              ),
              gap(12),
              TextFormField(
                controller: _p2,
                obscureText: _hide,
                decoration: const InputDecoration(
                    hintText: 'Ulangi sandi baru', prefixIcon: Icon(Icons.lock_outline_rounded)),
                validator: (v) => v != _p1.text ? 'Sandi tidak sama' : null,
              ),
            ],
            gap(22),
            PrimaryButton(
              label: _busy ? 'Memproses...' : (_step == 0 ? 'Kirim Kode' : (_step == 1 ? 'Verifikasi Kode' : 'Simpan Sandi Baru')),
              onPressed: _busy ? null : _next,
            ),
            if (_step == 1)
              Center(
                child: TextButton(
                  onPressed: () async {
                    await context.read<AuthProvider>().requestReset(_email.text);
                    if (mounted) toast(context, 'Kode baru dikirim. (Demo: ${AuthProvider.demoResetCode})');
                  },
                  child: Text('Kirim ulang kode',
                      style: ts(13, w: FontWeight.w800, c: AppColors.primaryDark)),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}