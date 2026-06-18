import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupVoiceCallScreen extends StatefulWidget {
  const GroupVoiceCallScreen({super.key});

  @override
  State<GroupVoiceCallScreen> createState() => _GroupVoiceCallScreenState();
}

class _GroupVoiceCallScreenState extends State<GroupVoiceCallScreen> {
  bool _isMuted = false;
  int _seconds = 0;
  Timer? _timer;
  final participants = DummyData.contacts.take(4).toList();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _duration {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.callGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Tim Medis Grup',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                _duration,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1,
                  ),
                  itemCount: participants.length,
                  itemBuilder: (context, i) => _ParticipantCard(
                    user: participants[i],
                    isSpeaking: i == 0,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallCtrl(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    color: _isMuted ? Colors.white : Colors.white.withOpacity(0.2),
                    iconColor: _isMuted ? AppColors.primary : Colors.white,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _CallCtrl(
                    icon: Icons.person_add_rounded,
                    label: 'Tambah',
                    color: Colors.white.withOpacity(0.2),
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                  _CallCtrl(
                    icon: Icons.call_end_rounded,
                    label: 'Tutup',
                    color: AppColors.callRed,
                    iconColor: Colors.white,
                    onTap: () => context.pop(),
                  ),
                  _CallCtrl(
                    icon: Icons.volume_up_rounded,
                    label: 'Speaker',
                    color: Colors.white.withOpacity(0.2),
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final dynamic user;
  final bool isSpeaking;

  const _ParticipantCard({required this.user, this.isSpeaking = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: isSpeaking
            ? Border.all(color: AppColors.callGreen, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VetenAvatar(name: user.name, imageUrl: user.avatarUrl, size: 64),
          const SizedBox(height: AppSpacing.sm),
          Text(
            user.name.split(' ').first,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (isSpeaking)
            const Icon(Icons.mic_rounded, color: AppColors.callGreen, size: 16),
        ],
      ),
    );
  }
}

class _CallCtrl extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _CallCtrl({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }
}
