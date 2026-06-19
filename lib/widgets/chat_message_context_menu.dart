import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../data/models/chat_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatMessageContextMenu extends StatelessWidget {
  final MessageModel message;
  final ValueChanged<String> onReact;

  const ChatMessageContextMenu({
    super.key,
    required this.message,
    required this.onReact,
  });

  static void show(BuildContext context, MessageModel message, ValueChanged<String> onReact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ChatMessageContextMenu(message: message, onReact: onReact),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Emojis Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEmoji(context, '👍'),
                _buildEmoji(context, '❤️'),
                _buildEmoji(context, '😂'),
                _buildEmoji(context, '😮'),
                _buildEmoji(context, '😢'),
                _buildEmoji(context, '🙏'),
                GestureDetector(
                  onTap: () {
                    _showEmojiPicker(context);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action List
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildAction(context, Icons.reply_rounded, 'Reply'),
                _buildAction(context, Icons.arrow_forward_rounded, 'Forward'),
                _buildAction(context, Icons.copy_rounded, 'Salin'),
                _buildAction(context, Icons.push_pin_outlined, 'Pin'),
                _buildAction(context, Icons.edit_outlined, 'Edit'),
                _buildAction(context, Icons.delete_outline_rounded, 'Hapus', isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmoji(BuildContext context, String emoji) {
    return GestureDetector(
      onTap: () {
        context.pop();
        onReact(emoji);
      },
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 26,
          fontFamilyFallback: ['Segoe UI Emoji', 'Noto Color Emoji', 'Apple Color Emoji'],
        ),
      ),
    );
  }

  void _showEmojiPicker(BuildContext context) {
    context.pop(); // Tutup context menu saat ini
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    context.pop(); // Tutup picker setelah memilih emoji
                    onReact(emoji.emoji);
                  },
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor: AppColors.surface,
                      columns: 7,
                      emojiSizeMax: 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                    ),
                    categoryViewConfig: const CategoryViewConfig(
                      backgroundColor: AppColors.surface,
                      indicatorColor: AppColors.primary,
                      iconColorSelected: AppColors.primary,
                      iconColor: AppColors.outlineVariant,
                    ),
                    bottomActionBarConfig: const BottomActionBarConfig(
                      showBackspaceButton: false,
                      showSearchViewButton: false,
                      backgroundColor: AppColors.surface,
                      buttonColor: AppColors.surface,
                      buttonIconColor: AppColors.outlineVariant,
                    ),
                    searchViewConfig: const SearchViewConfig(
                      backgroundColor: AppColors.surface,
                      buttonIconColor: AppColors.outlineVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String title, {bool isDestructive = false}) {
    return InkWell(
      onTap: () {
        context.pop();
        // Handle action logic
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? AppColors.danger : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDestructive ? AppColors.danger : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
