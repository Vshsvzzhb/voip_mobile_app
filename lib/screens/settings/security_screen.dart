import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Keamanan Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          const _SecurityCard(
            icon: Icons.verified_user_rounded,
            color: AppColors.callGreen,
            title: 'Akun Terverifikasi',
            subtitle: 'Nomor telepon Anda telah diverifikasi',
            trailing: Icon(Icons.check_circle_rounded,
                color: AppColors.callGreen, size: 20),
          ),
          const Divider(indent: AppSpacing.md),
          _SecurityCard(
            icon: Icons.lock_rounded,
            color: AppColors.primary,
            title: 'Ubah Kata Sandi',
            subtitle: 'Terakhir diubah 30 hari lalu',
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () {},
          ),
          _SecurityCard(
            icon: Icons.security_rounded,
            color: AppColors.secondary,
            title: 'Verifikasi Dua Langkah',
            subtitle: 'Tambah lapisan keamanan ekstra',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.tertiaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text('Aktifkan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.tertiary,
                  )),
            ),
            onTap: () {},
          ),
          _SecurityCard(
            icon: Icons.devices_rounded,
            color: AppColors.tertiary,
            title: 'Perangkat Terhubung',
            subtitle: '2 perangkat aktif',
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () {},
          ),
          const Divider(indent: AppSpacing.md),
          _SecurityCard(
            icon: Icons.lock_clock_rounded,
            color: AppColors.primary,
            title: 'Kunci Aplikasi',
            subtitle: 'Kunci VetenCall dengan sidik jari atau PIN',
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () => context.push('/app-lock'),
          ),
          _SecurityCard(
            icon: Icons.history_rounded,
            color: AppColors.onSurfaceVariant,
            title: 'Log Aktivitas',
            subtitle: 'Lihat riwayat masuk akun',
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SecurityCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }
}
