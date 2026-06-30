import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../data/models/chat_model.dart';
import '../../widgets/veten_avatar.dart';
import '../../widgets/veten_chat_bubble.dart';
import '../../widgets/chat_message_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoomScreen extends StatefulWidget {
  final String contactId;
  const ChatRoomScreen({super.key, required this.contactId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen>
    with TickerProviderStateMixin {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<MessageModel> _messages;
  late ChatModel _chat;

  // Entry animation for messages
  late final AnimationController _entryCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    _chat = DummyData.chats.firstWhere(
      (c) => c.id == widget.contactId,
      orElse: () => DummyData.chats.first,
    );
    _messages = List.from(_chat.messages);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty) return;
    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      text: _msgCtrl.text.trim(),
      time: DateTime.now(),
      status: MessageStatus.sending,
    );
    setState(() {
      _messages.add(msg);
      _msgCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
  }

  String _formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);

  bool _isNewDay(int idx) {
    if (idx == 0) return true;
    final cur = _messages[idx].time;
    final prev = _messages[idx - 1].time;
    return !DateUtils.isSameDay(cur, prev);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          // ─── GRADIENT HEADER ─────────────────────────────────
          _buildHeader(context),

          // ─── MESSAGES ────────────────────────────────────────
          Expanded(
            child: AnimatedBuilder(
              animation: _entryCtrl,
              builder: (_, child) => FadeTransition(
                opacity: _entryCtrl,
                child: child,
              ),
              child: ListView.builder(
                controller: _scrollCtrl,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final msg = _messages[i];
                  final isMe = msg.senderId == 'me';
                  final showTail = i == _messages.length - 1 ||
                      _messages[i + 1].senderId != msg.senderId;
                  return Column(
                    children: [
                      if (_isNewDay(i)) _DayDivider(time: msg.time),
                      Padding(
                        padding: EdgeInsets.only(
                          top: showTail ? AppSpacing.xs : 2,
                        ),
                        child: _AnimatedBubble(
                          key: ValueKey(msg.id),
                          isMe: isMe,
                          child: GestureDetector(
                            onLongPress: () {
                              ChatMessageContextMenu.show(context, msg, (emoji) {
                                setState(() {
                                  if (msg.reaction == emoji) {
                                    _messages[i] = msg.copyWith(clearReaction: true);
                                  } else {
                                    _messages[i] = msg.copyWith(reaction: emoji);
                                  }
                                });
                              });
                            },
                            child: VetenChatBubble(
                              text: msg.text,
                              isOutgoing: isMe,
                              time: _formatTime(msg.time),
                              isRead: msg.status == MessageStatus.read,
                              isDelivered: msg.status == MessageStatus.delivered,
                              showTail: showTail,
                              reaction: msg.reaction,
                              onReactionTap: () {
                                setState(() {
                                  _messages[i] = msg.copyWith(clearReaction: true);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // ─── INPUT BAR ───────────────────────────────────────
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0038C0), Color(0xFF1A56DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 8, 16),
          child: Row(
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => context.pop(),
              ),

              // Avatar
              VetenAvatar(
                name: _chat.contact.name,
                imageUrl: _chat.contact.avatarUrl,
                size: 40,
                showOnline: true,
                isOnline: _chat.contact.isOnline,
              ),
              const SizedBox(width: 10),

              // Name + status
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _chat.contact.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          if (_chat.contact.isOnline)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            _chat.contact.isOnline
                                ? 'Online'
                                : 'Terakhir dilihat tadi',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons
              _ActionBtn(
                icon: Icons.video_call_rounded,
                onTap: () => context.push('/video-call/${_chat.contact.id}'),
              ),
              _ActionBtn(
                icon: Icons.call_rounded,
                onTap: () => context.push('/voice-call/${_chat.contact.id}'),
              ),
              _ActionBtn(
                icon: Icons.more_horiz_rounded,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    final hasText = _msgCtrl.text.trim().isNotEmpty;
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attach
          _InputBtn(
            icon: Icons.attach_file_rounded,
            onTap: _showAttachmentMenu,
          ),
          const SizedBox(width: 6),

          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _msgCtrl,
                maxLines: null,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.plusJakartaSans(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppColors.onSurfaceVariant.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send / Mic
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: hasText
                ? GestureDetector(
                    key: const ValueKey('send'),
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0038C0), Color(0xFF1A56DB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A56DB).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  )
                : _InputBtn(
                    key: const ValueKey('mic'),
                    icon: Icons.mic_rounded,
                    onTap: () {},
                    color: AppColors.primary,
                  ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachItem(Icons.photo_library_rounded, const Color(0xFF2563EB), 'Galeri'),
                _buildAttachItem(Icons.camera_alt_rounded, const Color(0xFFDB2777), 'Kamera'),
                _buildAttachItem(Icons.location_on_rounded, const Color(0xFF059669), 'Lokasi'),
                _buildAttachItem(Icons.person_rounded, const Color(0xFF0891B2), 'Kontak'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachItem(Icons.insert_drive_file_rounded, const Color(0xFF7C3AED), 'Dokumen'),
                const SizedBox(width: 64),
                const SizedBox(width: 64),
                const SizedBox(width: 64),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachItem(IconData icon, Color color, String label) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ANIMATED BUBBLE — slides in from left/right when new message
// ============================================================
class _AnimatedBubble extends StatefulWidget {
  final bool isMe;
  final Widget child;

  const _AnimatedBubble({
    super.key,
    required this.isMe,
    required this.child,
  });

  @override
  State<_AnimatedBubble> createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<_AnimatedBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: Offset(widget.isMe ? 0.15 : -0.15, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  late final Animation<double> _fade = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

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

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ============================================================
// DAY DIVIDER
// ============================================================
class _DayDivider extends StatelessWidget {
  final DateTime time;
  const _DayDivider({required this.time});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              DateFormat('EEEE, dd MMMM', 'id').format(time),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
}

// ============================================================
// HEADER ACTION BUTTON
// ============================================================
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      );
}

// ============================================================
// INPUT ICON BUTTON
// ============================================================
class _InputBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _InputBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.onSurfaceVariant,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      );
}
