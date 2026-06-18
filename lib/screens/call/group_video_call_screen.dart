import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupVideoCallScreen extends StatelessWidget {
  const GroupVideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final participants = DummyData.contacts.take(4).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF050D1A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tim Medis (${participants.length} peserta)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                ),
                itemCount: participants.length,
                itemBuilder: (context, i) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1F36),
                    borderRadius: BorderRadius.circular(12),
                    border: i == 0
                        ? Border.all(color: AppColors.callGreen, width: 2)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: VetenAvatar(
                          name: participants[i].name,
                          imageUrl: participants[i].avatarUrl,
                          size: 70,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            participants[i].name.split(' ').first,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (i == 0)
                        const Positioned(
                          bottom: 8,
                          right: 8,
                          child: Icon(Icons.mic_rounded,
                              color: AppColors.callGreen, size: 16),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Btn(Icons.mic_rounded, Colors.white.withOpacity(0.15), Colors.white, () {}),
                  _Btn(Icons.videocam_rounded, Colors.white.withOpacity(0.15), Colors.white, () {}),
                  _Btn(Icons.call_end_rounded, AppColors.callRed, Colors.white, () => context.pop()),
                  _Btn(Icons.flip_camera_ios_rounded, Colors.white.withOpacity(0.15), Colors.white, () {}),
                  _Btn(Icons.person_add_rounded, Colors.white.withOpacity(0.15), Colors.white, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final VoidCallback onTap;
  const _Btn(this.icon, this.bg, this.iconColor, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
