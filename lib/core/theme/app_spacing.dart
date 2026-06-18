import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double containerPadding = 16.0;
  static const double gutter = 12.0;

  // Border radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 999.0;

  // Avatar
  static const double avatarSm = 36.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 60.0;
  static const double avatarXl = 80.0;

  // Icon
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // Touch target minimum
  static const double touchTarget = 44.0;

  // Button height
  static const double buttonHeight = 52.0;
  static const double inputHeight = 52.0;

  static EdgeInsets get pagePadding =>
      const EdgeInsets.symmetric(horizontal: md);

  static BorderRadius get cardRadius =>
      BorderRadius.circular(radiusXl);

  static BorderRadius get buttonRadius =>
      BorderRadius.circular(radiusFull);

  static BorderRadius get inputRadius =>
      BorderRadius.circular(radiusLg);
}
