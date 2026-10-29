import 'package:flutter/material.dart';

import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';

/// Pill that marks the build as a demo, so nobody mistakes it for the real thing.
class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key, this.label = AppStrings.demoLabel, this.onDark = false});

  final String label;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? Colors.white : AppColors.primaryDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withValues(alpha: 0.18) : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.science_outlined, size: 14, color: fg),
          Gap.w4,
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
          ),
        ],
      ),
    );
  }
}

/// One-line honest note, e.g. "Demo: no SMS is sent."
class DemoNote extends StatelessWidget {
  const DemoNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 16, color: AppColors.muted),
        Gap.w8,
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}
