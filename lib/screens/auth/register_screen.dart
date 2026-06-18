import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/veten_button.dart';
import '../../widgets/veten_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(text: '+62');
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/otp?phone=${_phoneCtrl.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Buat Akun Baru'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lengkapi Data Diri',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Isi informasi berikut untuk membuat akun',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                VetenTextField(
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama Anda',
                  controller: _nameCtrl,
                  prefix: const Icon(Icons.person_outline_rounded,
                      color: AppColors.onSurfaceVariant, size: 20),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                VetenTextField(
                  label: 'Nomor Telepon',
                  hint: '+62 812 3456 7890',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  prefix: const Icon(Icons.phone_outlined,
                      color: AppColors.onSurfaceVariant, size: 20),
                  validator: (v) =>
                      v == null || v.length < 10 ? 'Nomor telepon tidak valid' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                VetenTextField(
                  label: 'Kata Sandi',
                  hint: 'Minimal 6 karakter',
                  controller: _passCtrl,
                  obscureText: true,
                  prefix: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.onSurfaceVariant, size: 20),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Kata sandi minimal 6 karakter' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                VetenTextField(
                  label: 'Konfirmasi Kata Sandi',
                  hint: 'Ulangi kata sandi',
                  controller: _confirmCtrl,
                  obscureText: true,
                  prefix: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.onSurfaceVariant, size: 20),
                  validator: (v) =>
                      v != _passCtrl.text ? 'Kata sandi tidak cocok' : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                VetenButton(
                  label: 'Buat Akun',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14, color: AppColors.onSurfaceVariant),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Masuk',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
