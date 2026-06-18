import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _biometricEnabled = false;
  bool _pinEnabled = false;
  String _pin = '';
  bool _settingPin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kunci Aplikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _settingPin ? _buildPinSetup() : _buildOptions(),
    );
  }

  Widget _buildOptions() {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_rounded, color: AppColors.primary, size: 32),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Lindungi VetenCall Anda dengan kunci biometrik atau PIN.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13, color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SwitchListTile(
          title: const Text('Kunci Sidik Jari / Wajah'),
          subtitle: const Text('Gunakan biometrik untuk membuka aplikasi'),
          value: _biometricEnabled,
          onChanged: (v) => setState(() => _biometricEnabled = v),
          activeColor: AppColors.primary,
          secondary: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fingerprint_rounded,
                color: AppColors.primary, size: 20),
          ),
        ),
        const Divider(indent: AppSpacing.md),
        SwitchListTile(
          title: const Text('Kunci PIN'),
          subtitle: const Text('Buat kode PIN 6 digit'),
          value: _pinEnabled,
          onChanged: (v) {
            if (v) {
              setState(() => _settingPin = true);
            } else {
              setState(() => _pinEnabled = false);
            }
          },
          activeColor: AppColors.primary,
          secondary: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.pin_outlined,
                color: AppColors.secondary, size: 20),
          ),
        ),
        if (_pinEnabled) ...[
          const Divider(indent: AppSpacing.md),
          ListTile(
            title: const Text('Ubah PIN'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => setState(() => _settingPin = true),
          ),
        ],
      ],
    );
  }

  Widget _buildPinSetup() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.lock_rounded, color: AppColors.primary, size: 48),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Buat PIN Baru',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Masukkan PIN 6 digit untuk mengamankan aplikasi',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _pin.length ? AppColors.primary : AppColors.outlineVariant,
              ),
            )),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...[
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
            ['', '0', '⌫'],
          ].map((row) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((digit) => _PinBtn(
              digit: digit,
              onTap: () {
                if (digit == '⌫') {
                  if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1));
                } else if (digit.isNotEmpty && _pin.length < 6) {
                  setState(() => _pin += digit);
                  if (_pin.length == 6) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      setState(() {
                        _pinEnabled = true;
                        _settingPin = false;
                        _pin = '';
                      });
                    });
                  }
                }
              },
            )).toList(),
          )),
        ],
      ),
    );
  }
}

class _PinBtn extends StatelessWidget {
  final String digit;
  final VoidCallback onTap;

  const _PinBtn({required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (digit.isEmpty) return const SizedBox(width: 72, height: 72);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Center(
          child: Text(
            digit,
            style: GoogleFonts.plusJakartaSans(
              fontSize: digit == '⌫' ? 20 : 22,
              fontWeight: FontWeight.w600,
              color: AppColors.onBackground,
            ),
          ),
        ),
      ),
    );
  }
}
