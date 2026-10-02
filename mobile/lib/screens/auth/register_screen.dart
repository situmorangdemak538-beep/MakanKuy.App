import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'customer';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();

    final success = await provider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      _role,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Registrasi gagal',
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      _role == 'restaurant_admin'
          ? AppRoutes.adminDashboard
          : AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: Validators.validateName,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                validator: Validators.validatePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(
                  labelText: 'Jenis Akun',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'customer',
                    child: Text('Customer'),
                  ),
                  DropdownMenuItem(
                    value: 'restaurant_admin',
                    child: Text('Admin Restoran'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _role = value);
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _register,
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Daftar'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.login,
                  );
                },
                child: const Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}