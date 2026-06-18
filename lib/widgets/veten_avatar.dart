import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class VetenAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool showOnline;
  final bool isOnline;
  final bool isGroup;

  const VetenAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = AppSpacing.avatarMd,
    this.showOnline = false,
    this.isOnline = false,
    this.isGroup = false,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get _bgColor {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      const Color(0xFF6750A4),
      const Color(0xFF0277BD),
    ];
    final index = name.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = size * 0.26;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _bgColor.withOpacity(0.15),
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildInitials();
                },
              ),
            )
          : _buildInitials(),
    );

    if (!showOnline) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? AppColors.online : AppColors.onSurfaceVariant.withOpacity(0.4),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitials() {
    return Center(
      child: isGroup
          ? Icon(Icons.group_rounded,
              color: _bgColor, size: size * 0.5)
          : Text(
              _initials,
              style: TextStyle(
                color: _bgColor,
                fontSize: size * 0.38,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
