import 'package:flutter/widgets.dart';

/// Spacing, radius and control sizes (8-pt grid, docs/FLOW.md §2).
abstract final class AppSizes {
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
  static const s40 = 40.0;

  static const screenPadding = 20.0;

  static const radiusButton = 14.0;
  static const radiusInput = 12.0;
  static const radiusCard = 16.0;
  static const radiusSheet = 24.0;

  static const buttonHeight = 52.0;
  static const inputHeight = 52.0;
  static const minTouch = 44.0;
  static const avatar = 44.0;
}

/// Ready-made const gaps so layouts stay on the grid.
abstract final class Gap {
  static const h4 = SizedBox(height: AppSizes.s4);
  static const h8 = SizedBox(height: AppSizes.s8);
  static const h12 = SizedBox(height: AppSizes.s12);
  static const h16 = SizedBox(height: AppSizes.s16);
  static const h24 = SizedBox(height: AppSizes.s24);
  static const h32 = SizedBox(height: AppSizes.s32);

  static const w4 = SizedBox(width: AppSizes.s4);
  static const w8 = SizedBox(width: AppSizes.s8);
  static const w12 = SizedBox(width: AppSizes.s12);
  static const w16 = SizedBox(width: AppSizes.s16);
}
