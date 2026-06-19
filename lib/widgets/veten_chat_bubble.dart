import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class VetenChatBubble extends StatelessWidget {
  final String text;
  final bool isOutgoing;
  final String time;
  final bool isRead;
  final bool isDelivered;
  final bool showTail;
  final String? reaction;
  final VoidCallback? onReactionTap;

  const VetenChatBubble({
    super.key,
    required this.text,
    required this.isOutgoing,
    required this.time,
    this.isRead = false,
    this.isDelivered = false,
    this.showTail = true,
    this.reaction,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: EdgeInsets.only(
          left: isOutgoing ? AppSpacing.xl : 0,
          right: isOutgoing ? 0 : AppSpacing.xl,
          bottom: AppSpacing.xs,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              painter: _BubblePainter(
                isOutgoing: isOutgoing,
                color: isOutgoing
                    ? AppColors.outgoingBubble
                    : AppColors.incomingBubble,
                showTail: showTail,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        height: 1.4,
                        color: isOutgoing
                            ? AppColors.outgoingBubbleText
                            : AppColors.incomingBubbleText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isOutgoing
                                ? Colors.white.withOpacity(0.7)
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                        if (isOutgoing) ...[
                          const SizedBox(width: 3),
                          Icon(
                            isRead
                                ? Icons.done_all_rounded
                                : isDelivered
                                    ? Icons.done_all_rounded
                                    : Icons.done_rounded,
                            size: 14,
                            color: isRead
                                ? Colors.lightBlue[200]
                                : Colors.white.withOpacity(0.7),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (reaction != null)
              Positioned(
                bottom: -10,
                right: isOutgoing ? null : 10,
                left: isOutgoing ? 10 : null,
                child: GestureDetector(
                  onTap: onReactionTap,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      reaction!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamilyFallback: ['Segoe UI Emoji', 'Noto Color Emoji', 'Apple Color Emoji'],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final bool isOutgoing;
  final Color color;
  final bool showTail;

  _BubblePainter({
    required this.isOutgoing,
    required this.color,
    required this.showTail,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const r = 16.0;
    const tailR = 4.0;

    final path = Path();
    if (isOutgoing) {
      path.moveTo(0, r);
      path.quadraticBezierTo(0, 0, r, 0);
      path.lineTo(size.width - r, 0);
      path.quadraticBezierTo(size.width, 0, size.width, r);
      path.lineTo(size.width, size.height - r);
      if (showTail) {
        path.quadraticBezierTo(
            size.width, size.height, size.width - tailR, size.height);
      } else {
        path.quadraticBezierTo(
            size.width, size.height, size.width - r, size.height);
      }
      path.lineTo(r, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - r);
    } else {
      path.moveTo(r, 0);
      path.lineTo(size.width - r, 0);
      path.quadraticBezierTo(size.width, 0, size.width, r);
      path.lineTo(size.width, size.height - r);
      path.quadraticBezierTo(
          size.width, size.height, size.width - r, size.height);
      path.lineTo(r, size.height);
      if (showTail) {
        path.quadraticBezierTo(0, size.height, tailR, size.height - tailR);
        path.quadraticBezierTo(0, size.height - tailR, 0, size.height - r);
      } else {
        path.quadraticBezierTo(0, size.height, 0, size.height - r);
      }
      path.lineTo(0, r);
      path.quadraticBezierTo(0, 0, r, 0);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
