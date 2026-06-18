import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../data/models/call_model.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = DummyData.callLogs;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Panggilan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.onBackground,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/incoming-call'),
        backgroundColor: AppColors.callGreen,
        child: const Icon(Icons.call_rounded, color: Colors.white),
      ),
      body: ListView.separated(
        itemCount: logs.length,
        separatorBuilder: (_, __) => const Divider(
          indent: 76,
          height: 0,
          color: AppColors.outlineVariant,
        ),
        itemBuilder: (context, i) {
          final log = logs[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 6,
            ),
            leading: VetenAvatar(
              name: log.contact.name,
              imageUrl: log.contact.avatarUrl,
              size: AppSpacing.avatarMd,
            ),
            title: Text(
              log.contact.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: log.isMissed ? AppColors.callRed : AppColors.onBackground,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  _callIcon(log.type),
                  size: 14,
                  color: log.isMissed ? AppColors.callRed : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  _callLabel(log),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: log.isMissed
                        ? AppColors.callRed
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(log.time),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  log.isVideo ? Icons.video_call_rounded : Icons.call_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
            onTap: () => log.isVideo
                ? context.push('/video-call/${log.contact.id}')
                : context.push('/voice-call/${log.contact.id}'),
          );
        },
      ),
    );
  }

  IconData _callIcon(CallType type) {
    switch (type) {
      case CallType.voiceIncoming:
      case CallType.videoIncoming:
        return Icons.call_received_rounded;
      case CallType.voiceOutgoing:
      case CallType.videoOutgoing:
        return Icons.call_made_rounded;
      case CallType.voiceMissed:
      case CallType.videoMissed:
        return Icons.call_missed_rounded;
    }
  }

  String _callLabel(CallLogModel log) {
    if (log.isMissed) return 'Tidak terjawab';
    final dur = log.duration;
    if (dur == Duration.zero) return log.isIncoming ? 'Masuk' : 'Keluar';
    final m = dur.inMinutes.toString().padLeft(2, '0');
    final s = (dur.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return DateFormat('HH:mm').format(dt);
    if (diff.inDays == 1) return 'Kemarin';
    return DateFormat('dd MMM').format(dt);
  }
}
