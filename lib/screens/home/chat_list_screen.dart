import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../data/models/chat_model.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  final chats = DummyData.chats;

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

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return DateFormat('HH:mm').format(dt);
    if (diff.inDays == 1) return 'Kemarin';
    return DateFormat('dd/MM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final totalUnread = chats.fold<int>(0, (sum, c) => sum + c.unreadCount);

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VetenCall',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                if (totalUnread > 0)
                                  Text(
                                    '$totalUnread pesan belum dibaca',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                              ],
                            ),
                            const Spacer(),
                            _HeaderBtn(
                              icon: Icons.search_rounded,
                              onTap: () => context.push('/chat-search'),
                            ),
                            const SizedBox(width: 8),
                            _HeaderBtn(
                              icon: Icons.more_horiz_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── SECTION LABEL ───────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeSlide(
              delay: 100,
              ctrl: _ctrl,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      'Pesan',
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
                        color: AppColors.outlineVariant.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (totalUnread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$totalUnread baru',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ─── CHAT LIST ───────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final chat = chats[i];
                  return _FadeSlide(
                    delay: 140 + (i * 70),
                    ctrl: _ctrl,
                    child: _ChatCard(
                      chat: chat,
                      timeStr: _formatTime(chat.lastMessageTime),
                      isFirst: i == 0,
                      isLast: i == chats.length - 1,
                      onTap: () => context.push('/chat/${chat.id}'),
                    ),
                  );
                },
                childCount: chats.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // ─── FAB ─────────────────────────────────────────────
      floatingActionButton: _FadeSlide(
        delay: 500,
        ctrl: _ctrl,
        child: GestureDetector(
          onTap: () => context.push('/contacts'),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0038C0), Color(0xFF1A56DB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A56DB).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.chat_rounded, color: Colors.white, size: 24),
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
// CHAT CARD
// ============================================================
class _ChatCard extends StatefulWidget {
  final ChatModel chat;
  final String timeStr;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _ChatCard({
    required this.chat,
    required this.timeStr,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<_ChatCard>
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
    final hasUnread = widget.chat.unreadCount > 0;

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
            color: hasUnread
                ? const Color(0xFFF0F5FF) // Sedikit biru jika ada unread
                : Colors.white,
            borderRadius: radius,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Avatar
                    VetenAvatar(
                      name: widget.chat.contact.name,
                      imageUrl: widget.chat.contact.avatarUrl,
                      size: AppSpacing.avatarLg,
                      showOnline: true,
                      isOnline: widget.chat.contact.isOnline,
                      isGroup: widget.chat.isGroup,
                    ),
                    const SizedBox(width: 12),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + time
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.chat.contact.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: hasUnread
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: const Color(0xFF1E293B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.timeStr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: hasUnread
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: hasUnread
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Last message + badge
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.chat.lastMessage,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: hasUnread
                                        ? const Color(0xFF334155)
                                        : AppColors.onSurfaceVariant,
                                    fontWeight: hasUnread
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              if (hasUnread) ...[
                                const SizedBox(width: 8),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${widget.chat.unreadCount}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              if (!widget.isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 80),
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
