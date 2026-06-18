import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Stack(
                      children: [
                        VetenAvatar(
                            name: user.name,
                            imageUrl: user.avatarUrl,
                            size: 90),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.tertiaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      user.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.phone,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, color: Colors.white.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () => context.push('/edit-profile'),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _ProfileCard(
                    children: [
                      _InfoRow(
                        icon: Icons.info_outline_rounded,
                        label: 'Bio',
                        value: user.bio,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ProfileCard(
                    label: 'Akun',
                    children: [
                      _NavTile(
                        icon: Icons.lock_outline_rounded,
                        label: 'Keamanan Akun',
                        color: AppColors.primary,
                        onTap: () => context.push('/security'),
                      ),
                      _NavTile(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privasi',
                        color: AppColors.secondary,
                        onTap: () => context.push('/privacy'),
                      ),
                      _NavTile(
                        icon: Icons.notifications_outlined,
                        label: 'Notifikasi',
                        color: AppColors.tertiary,
                        onTap: () => context.push('/notifications'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ProfileCard(
                    label: 'Preferensi',
                    children: [
                      _NavTile(
                        icon: Icons.record_voice_over_rounded,
                        label: 'Pengaturan TTS',
                        color: AppColors.primary,
                        onTap: () => context.push('/tts-settings'),
                      ),
                      _NavTile(
                        icon: Icons.storage_rounded,
                        label: 'Kelola Penyimpanan',
                        color: AppColors.secondary,
                        onTap: () => context.push('/storage'),
                      ),
                      _NavTile(
                        icon: Icons.lock_clock_rounded,
                        label: 'Kunci Aplikasi',
                        color: AppColors.tertiary,
                        onTap: () => context.push('/app-lock'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ProfileCard(
                    label: 'Sosial',
                    children: [
                      _NavTile(
                        icon: Icons.person_add_outlined,
                        label: 'Permintaan Pertemanan',
                        color: AppColors.primary,
                        onTap: () => context.push('/friend-requests'),
                      ),
                      _NavTile(
                        icon: Icons.block_rounded,
                        label: 'Pengguna Diblokir',
                        color: AppColors.error,
                        onTap: () => context.push('/blocked-users'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ProfileCard(
                    children: [
                      _NavTile(
                        icon: Icons.logout_rounded,
                        label: 'Keluar',
                        color: AppColors.error,
                        isDestructive: true,
                        onTap: () => context.go('/login'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String? label;
  final List<Widget> children;

  const _ProfileCard({this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Text(
                label!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, color: AppColors.onSurfaceVariant)),
                Text(value,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, color: AppColors.onBackground)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppColors.error : AppColors.onBackground,
        ),
      ),
      trailing: isDestructive
          ? null
          : const Icon(Icons.chevron_right_rounded,
              color: AppColors.onSurfaceVariant, size: 20),
      onTap: onTap,
    );
  }
}
