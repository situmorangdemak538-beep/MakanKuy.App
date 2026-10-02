import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();

    final success = await provider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Login gagal',
          ),
        ),
      );
      return;
    }

    final role = provider.user?.role;

    if (role == 'restaurant_admin') {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.adminDashboard,
      );
    } else if (role == 'administrator') {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.administratorDashboard,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.restaurant_menu,
                size: 75,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang di MakanKuy',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon:
                      const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _login,
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.register,
                  );
                },
                child: const Text(
                  'Belum punya akun? Daftar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}