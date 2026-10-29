import 'package:flutter/material.dart';

/// Brand colour tokens from docs/FLOW.md §2.
/// Widgets use these (or the Theme), never raw hex values.
abstract final class AppColors {
  static const primary = Color(0xFFF36B21);
  static const primaryLight = Color(0xFFFF8A36);
  static const primaryDark = Color(0xFFD94910);
  static const primarySoft = Color(0xFFFFF0E7);

  static const navy = Color(0xFF15243C);
  static const ink = Color(0xFF243044);
  static const muted = Color(0xFF6D7788);
  static const line = Color(0xFFE2E7EE);
  static const bg = Color(0xFFF4F6F9);
  static const surface = Color(0xFFFFFFFF);

  static const success = Color(0xFF167C59);
  static const successSoft = Color(0xFFE5F3EE);
  static const warning = Color(0xFFE8A317);
  static const warningSoft = Color(0xFFFDF4E1);
  static const error = Color(0xFFB54732);

  static const mapWater = Color(0xFFCFE6F5);
  static const mapLand = Color(0xFFEEF3E6);

  /// CTA buttons: primary → primaryLight, left to right.
  static const ctaGradient = LinearGradient(colors: [primary, primaryLight]);

  /// Splash background: primaryDark → primaryLight at 135°.
  static const splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryLight],
  );

  /// Soft card shadow: 0 4 16 rgba(21,36,60,0.06).
  static const cardShadow = [BoxShadow(color: Color(0x0F15243C), blurRadius: 16, offset: Offset(0, 4))];
}
