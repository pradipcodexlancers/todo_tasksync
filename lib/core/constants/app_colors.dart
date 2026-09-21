import 'package:flutter/material.dart';

/// Application Color Palette
///
/// Tailored design tokens matching the My Tasks UI.
class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFF7065F0);
  static const Color primaryDark = Color(0xFF5B50D6);
  static const Color primaryLight = Color(0xFFEDE9FE);

  // Background & Surfaces
  static const Color scaffoldBackground = Color(0xFFF7F5F0);
  static const Color cardSurface = Colors.white;
  static const Color darkSurface = Color(0xFF1E202C);
  static const Color cardShadow = Color(0x0A000000);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E2432);
  static const Color textSecondary = Color(0xFF8A8FA3);
  static const Color textMuted = Color(0xFFA5AAB9);
  static const Color textLight = Colors.white;

  // Checkbox Colors
  static const Color checkboxBorder = Color(0xFFD4D0F8);
  static const Color checkboxCheckedBg = Color(0xFF10B981);

  // Sync Badge
  static const Color syncBadgeBg = Color(0xFFD1FAE5);
  static const Color syncBadgeText = Color(0xFF059669);
  static const Color syncBadgeDot = Color(0xFF10B981);

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Priority Colors
  static const Color priorityHighBg = Color(0xFFFEE2E2);
  static const Color priorityHighText = Color(0xFFEF4444);
  static const Color priorityHighDot = Color(0xFFEF4444);

  static const Color priorityMedBg = Color(0xFFFEF3C7);
  static const Color priorityMedText = Color(0xFFD97706);
  static const Color priorityMedDot = Color(0xFFF59E0B);

  static const Color priorityLowBg = Color(0xFFD1FAE5);
  static const Color priorityLowText = Color(0xFF059669);
  static const Color priorityLowDot = Color(0xFF10B981);

  // Tag Badges
  static const Color tagWorkBg = Color(0xFFCCFBF1);
  static const Color tagWorkText = Color(0xFF0D9488);

  static const Color tagStudyBg = Color(0xFFDCFCE7);
  static const Color tagStudyText = Color(0xFF16A34A);

  static const Color tagPersonalBg = Color(0xFFFFEDD5);
  static const Color tagPersonalText = Color(0xFFEA580C);

  // Pending Sync
  static const Color pendingSyncBg = Color(0xFFFEF3C7);
  static const Color pendingSyncText = Color(0xFFD97706);

  // Inactive elements
  static const Color inactiveNav = Color(0xFF94A3B8);
  static const Color iconLight = Color(0xFF64748B);
  static const Color circleButtonBg = Color(0xFFFFFFFF);
}
