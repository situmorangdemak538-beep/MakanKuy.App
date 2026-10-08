import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _agree = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  String? _req(String? v, String label) =>
      (v ?? '').trim().isEmpty ? '$label wajib diisi' : null;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (!_agree) {
      toast(context, 'Setujui Syarat & Ketentuan terlebih dahulu');
      return;
    }
    final auth = context.read<AuthProvider>();
    await auth.register(_name.text, _phone.text, _email.text);
    if (!mounted) return;
    goHome(context, auth.user!.role);
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Text(t, style: ts(13, w: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().loading;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Form(
            key: _form,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_rounded)),
                const Spacer(),
                const Pill(
                    text: 'MAKANKUY',
                    bg: AppColors.peach,
                    fg: AppColors.primaryDark,
                    icon: Icons.local_fire_department),
              ]),
              gap(8),
              Text('Buat Akun Baru', style: ts(26, w: FontWeight.w800)),
              gap(6),
              Text('Daftar untuk reservasi meja cepat di resto UMKM Ternate & sekitarnya.',
                  style: ts(14, c: AppColors.muted, h: 1.5)),
              _label('Nama Lengkap'),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                    hintText: 'Nama lengkap',
                    prefixIcon: Icon(Icons.person_outline_rounded)),
                validator: (v) => _req(v, 'Nama'),
              ),
              _label('Nomor WhatsApp / HP'),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: '+62 812-0000-0000',
                    prefixIcon: Icon(Icons.phone_iphone_rounded),
                    helperText: 'Konfirmasi booking dikirim via WhatsApp'),
                validator: (v) => _req(v, 'Nomor HP'),
              ),
              _label('Alamat Email'),
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
              _label('Kata Sandi'),
              TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Minimal 8 karakter',
                    prefixIcon: Icon(Icons.lock_outline_rounded)),
                validator: (v) =>
                    (v ?? '').length < 8 ? 'Minimal 8 karakter' : null,
              ),
              gap(10),
              Row(children: [
                Checkbox(
                    value: _agree,
                    activeColor: AppColors.green,
                    onChanged: (v) => setState(() => _agree = v ?? false)),
                Expanded(
                    child: Text('Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi MakanKuy Ternate.',
                        style: ts(12, c: AppColors.muted, h: 1.4))),
              ]),
              gap(12),
              PrimaryButton(
                label: loading ? 'Memproses...' : 'Daftar Akun MakanKuy',
                icon: loading ? null : Icons.arrow_forward_rounded,
                onPressed: loading ? null : _submit,
              ),
              gap(16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Text.rich(TextSpan(
                      text: 'Sudah punya akun? ',
                      style: ts(14, c: AppColors.muted),
                      children: [
                        TextSpan(
                            text: 'Masuk di sini',
                            style: ts(14,
                                w: FontWeight.w800, c: AppColors.primaryDark))
                      ])),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}