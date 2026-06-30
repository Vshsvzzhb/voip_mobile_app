import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../data/models/call_model.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class CallLogScreen extends StatefulWidget {
  const CallLogScreen({super.key});

  @override
  State<CallLogScreen> createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final logs = DummyData.callLogs;
    final missedCount = logs.where((l) => l.isMissed).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── GRADIENT HEADER ─────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeSlide(
              delay: 0,
              ctrl: _ctrl,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0038C0), Color(0xFF1A56DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panggilan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            if (missedCount > 0)
                              Text(
                                '$missedCount panggilan tidak terjawab',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        _HeaderBtn(icon: Icons.search_rounded, onTap: () {}),
                        const SizedBox(width: 8),
                        _HeaderBtn(icon: Icons.more_horiz_rounded, onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── STATS CARDS ─────────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeSlide(
              delay: 100,
              ctrl: _ctrl,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    _StatCard(
                      icon: Icons.call_received_rounded,
                      label: 'Masuk',
                      count: logs.where((l) => l.isIncoming && !l.isMissed).length,
                      color: const Color(0xFF059669),
                      bg: const Color(0xFFECFDF5),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      icon: Icons.call_made_rounded,
                      label: 'Keluar',
                      count: logs.where((l) => !l.isIncoming && !l.isMissed).length,
                      color: const Color(0xFF2563EB),
                      bg: const Color(0xFFEFF6FF),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      icon: Icons.call_missed_rounded,
                      label: 'Tidak Terjawab',
                      count: missedCount,
                      color: const Color(0xFFDC2626),
                      bg: const Color(0xFFFFF0F0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── SECTION LABEL ───────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeSlide(
              delay: 160,
              ctrl: _ctrl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Riwayat',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                          height: 1,
                          color: AppColors.outlineVariant.withOpacity(0.4)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── CALL LOG LIST ───────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final log = logs[i];
                  return _FadeSlide(
                    delay: 200 + (i * 65),
                    ctrl: _ctrl,
                    child: _CallCard(
                      log: log,
                      timeStr: _formatDate(log.time),
                      callIcon: _callIcon(log.type),
                      callLabel: _callLabel(log),
                      isFirst: i == 0,
                      isLast: i == logs.length - 1,
                      onTap: () => log.isVideo
                          ? context.push('/video-call/${log.contact.id}')
                          : context.push('/voice-call/${log.contact.id}'),
                    ),
                  );
                },
                childCount: logs.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // ─── FAB ─────────────────────────────────────────────────
      floatingActionButton: _FadeSlide(
        delay: 500,
        ctrl: _ctrl,
        child: GestureDetector(
          onTap: () => context.push('/incoming-call'),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.call_rounded, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FADE + SLIDE WRAPPER
// ============================================================
class _FadeSlide extends StatelessWidget {
  final int delay;
  final AnimationController ctrl;
  final Widget child;

  const _FadeSlide({
    required this.delay,
    required this.ctrl,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final maxMs = 900.0;
    final start = (delay / maxMs).clamp(0.0, 1.0);
    final end = ((delay + 400) / maxMs).clamp(0.0, 1.0);

    final slide = Tween<Offset>(
      begin: const Offset(0.0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: ctrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ));

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, child) => FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      ),
      child: child,
    );
  }
}

// ============================================================
// HEADER BUTTON
// ============================================================
class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      );
}

// ============================================================
// STAT CARD
// ============================================================
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final Color bg;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                '$count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

// ============================================================
// CALL CARD
// ============================================================
class _CallCard extends StatefulWidget {
  final CallLogModel log;
  final String timeStr;
  final IconData callIcon;
  final String callLabel;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _CallCard({
    required this.log,
    required this.timeStr,
    required this.callIcon,
    required this.callLabel,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_CallCard> createState() => _CallCardState();
}

class _CallCardState extends State<_CallCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.97)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMissed = widget.log.isMissed;
    final missedColor = const Color(0xFFDC2626);

    final radius = BorderRadius.vertical(
      top: widget.isFirst ? const Radius.circular(18) : Radius.zero,
      bottom: widget.isLast ? const Radius.circular(18) : Radius.zero,
    );

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: isMissed ? const Color(0xFFFFF8F8) : Colors.white,
            borderRadius: radius,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Avatar
                    VetenAvatar(
                      name: widget.log.contact.name,
                      imageUrl: widget.log.contact.avatarUrl,
                      size: AppSpacing.avatarMd,
                    ),
                    const SizedBox(width: 12),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.log.contact.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isMissed
                                  ? missedColor
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                widget.callIcon,
                                size: 13,
                                color: isMissed
                                    ? missedColor
                                    : AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.callLabel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: isMissed
                                      ? missedColor
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Right: time + call button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.timeStr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: widget.log.isVideo
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.log.isVideo
                                ? Icons.video_call_rounded
                                : Icons.call_rounded,
                            color: widget.log.isVideo
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF059669),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider
              if (!widget.isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 76),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.outlineVariant.withOpacity(0.4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
