import 'package:flutter/material.dart';

import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';

/// Gradient call-to-action button (primary → primaryLight).
/// Pass `onPressed: null` to disable it.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final radius = BorderRadius.circular(AppSizes.radiusButton);

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: enabled || loading ? 1 : 0.45,
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.ctaGradient, borderRadius: radius),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: enabled ? onPressed : null,
              child: SizedBox(
                height: AppSizes.buttonHeight,
                child: Center(
                  child: loading
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[Icon(icon, color: Colors.white, size: 20), Gap.w8],
                            Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
