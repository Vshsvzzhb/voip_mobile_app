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

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<MessageModel> _messages;
  late ChatModel _chat;

  @override
  void initState() {
    super.initState();
    _chat = DummyData.chats.firstWhere(
      (c) => c.id == widget.contactId,
      orElse: () => DummyData.chats.first,
    );
    _messages = List.from(_chat.messages);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
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
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: InkWell(
          onTap: () {},
          child: Row(
            children: [
              VetenAvatar(
                name: _chat.contact.name,
                imageUrl: _chat.contact.avatarUrl,
                size: 38,
                showOnline: true,
                isOnline: _chat.contact.isOnline,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _chat.contact.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onBackground,
                      ),
                    ),
                    Text(
                      _chat.contact.isOnline ? 'Online' : 'Terakhir dilihat tadi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _chat.contact.isOnline
                            ? AppColors.online
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call_rounded),
            onPressed: () =>
                context.push('/video-call/${_chat.contact.id}'),
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded),
            onPressed: () =>
                context.push('/voice-call/${_chat.contact.id}'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
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
                    if (_isNewDay(i))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              DateFormat('EEEE, dd MMMM', 'id').format(msg.time),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: showTail ? AppSpacing.xs : 2,
                      ),
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
                  ],
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file_rounded,
                color: AppColors.onSurfaceVariant),
            onPressed: _showAttachmentMenu,
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                border: Border.all(color: AppColors.outlineVariant),
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
                    color: AppColors.onSurfaceVariant.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: _msgCtrl.text.trim().isEmpty
                ? IconButton(
                    icon: const Icon(Icons.mic_rounded,
                        color: AppColors.primary, size: 26),
                    onPressed: () {},
                  )
                : GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
  void _showAttachmentMenu() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 84, // Jarak di atas input bar
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface, // Warna putih/surface yang bersih
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAttachItem(Icons.photo_library_rounded, const Color(0xFF007BFF), 'Galeri'),
                      _buildAttachItem(Icons.camera_alt_rounded, const Color(0xFFE91E63), 'Kamera'),
                      _buildAttachItem(Icons.location_on_rounded, const Color(0xFF00C853), 'Lokasi'),
                      _buildAttachItem(Icons.person_rounded, const Color(0xFF03A9F4), 'Kontak'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAttachItem(Icons.insert_drive_file_rounded, const Color(0xFF673AB7), 'Dokumen'),
                      const SizedBox(width: 64), // Placeholder untuk menjaga jarak yang sama dengan baris atas
                      const SizedBox(width: 64),
                      const SizedBox(width: 64),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachItem(IconData icon, Color color, String label) {
    return GestureDetector(
      onTap: () {
        context.pop(); // Tutup menu saat dipilih
      },
      child: SizedBox(
        width: 64, // Memastikan lebar item seragam agar teks panjang tidak merusak layout
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
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
