import 'package:flutter_svg/flutter_svg.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 28),
                  const SizedBox(width: 8),
                  Text(
                    'VetenCall',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/images/screen_2.png', fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Bergabung dengan\nVetenCall',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dapatkan akses instan ke konsultasi\nkesehatan profesional kapan saja.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Container(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5), width: 1)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Masuk',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
                              ),
                              child: Center(
                                child: Text(
                                  'Daftar',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      VetenTextField(
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap',
                        controller: _nameCtrl,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      VetenTextField(
                        label: 'Nomor HP atau Email',
                        hint: 'Masukkan nomor HP atau email',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      VetenTextField(
                        label: 'Kata Sandi',
                        hint: 'Buat kata sandi minimal 6 karakter',
                        controller: _passCtrl,
                        obscureText: true,
                        validator: (v) =>
                            v == null || v.length < 6 ? 'Kata sandi minimal 6 karakter' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      VetenButton(
                        label: 'Daftar',
                        onPressed: _register,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.outlineVariant.withOpacity(0.5))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Text(
                              'ATAU',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.outlineVariant.withOpacity(0.5))),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      OutlinedButton(
                        onPressed: () => context.go('/home'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          side: const BorderSide(color: AppColors.outlineVariant),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Lanjutkan dengan Google',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
