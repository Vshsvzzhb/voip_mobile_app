import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Calm Blue
  static const Color primary = Color(0xFF0055CE);
  static const Color primaryContainer = Color(0xFF2F6FED);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFFFF);
  static const Color primaryFixed = Color(0xFFDAE2FF);
  static const Color primaryFixedDim = Color(0xFFB1C5FF);
  static const Color inversePrimary = Color(0xFFB1C5FF);

  // Secondary - Teal
  static const Color secondary = Color(0xFF006A60);
  static const Color secondaryContainer = Color(0xFF61F6E3);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF006F64);

  // Tertiary - Soft Orange (Accent/CTA)
  static const Color tertiary = Color(0xFF994500);
  static const Color tertiaryContainer = Color(0xFFBE5908);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFFFFFFF);

  // Surface & Background
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFD9DADC);
  static const Color surfaceBright = Color(0xFFF8F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFEDEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE7E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE1E2E4);
  static const Color surfaceVariant = Color(0xFFE1E2E4);
  static const Color surfaceTint = Color(0xFF0056D0);
  static const Color inverseSurface = Color(0xFF2E3132);
  static const Color inverseOnSurface = Color(0xFFF0F1F3);

  // On-Surface
  static const Color onBackground = Color(0xFF191C1E);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF424654);

  // Outline
  static const Color outline = Color(0xFF737786);
  static const Color outlineVariant = Color(0xFFC2C6D7);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Semantic Colors
  static const Color success = Color(0xFF2ED47A);
  static const Color warning = Color(0xFFFF8A3D);
  static const Color danger = Color(0xFFFF4757);
  static const Color callGreen = Color(0xFF2ED47A);
  static const Color callRed = Color(0xFFFF4757);
  static const Color online = Color(0xFF2ED47A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0055CE), Color(0xFF2F6FED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient callGradient = LinearGradient(
    colors: [Color(0xFF0A1628), Color(0xFF1A2F5A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Chat Bubble Colors
  static const Color outgoingBubble = Color(0xFF2F6FED);
  static const Color incomingBubble = Color(0xFFF2F4F6);
  static const Color outgoingBubbleText = Color(0xFFFFFFFF);
  static const Color incomingBubbleText = Color(0xFF191C1E);
}
