import 'package:flutter/material.dart';

import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';

/// Circle with a person's initials. Used instead of photos in the POC.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.initials, {super.key, this.size = AppSizes.avatar});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.navy,
      child: Text(
        initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.36),
      ),
    );
  }
}

/// White card with standard padding and an optional title.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[Text(title!, style: Theme.of(context).textTheme.titleMedium), Gap.h12],
            child,
          ],
        ),
      ),
    );
  }
}

/// "Label ........ Value" row for summaries and receipts.
class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key, this.emphasis = false});

  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: emphasis ? text.titleSmall : text.bodyMedium?.copyWith(color: AppColors.muted)),
          ),
          Gap.w12,
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: emphasis ? text.titleMedium : text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Big green tick with a title, for confirmation screens.
class SuccessHeader extends StatelessWidget {
  const SuccessHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: const BoxDecoration(color: AppColors.successSoft, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, size: 48, color: AppColors.success),
        ),
        Gap.h16,
        Text(title, textAlign: TextAlign.center, style: text.headlineSmall),
        if (subtitle != null) ...[
          Gap.h8,
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: AppColors.muted),
          ),
        ],
      ],
    );
  }
}

/// Coloured pill tag, e.g. "Saves 9 kg CO₂" or "1 seat left".
class TagPill extends StatelessWidget {
  const TagPill(
    this.label, {
    super.key,
    this.color = AppColors.success,
    this.background = AppColors.successSoft,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 13, color: color), Gap.w4],
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

/// Text-only wordmark until the approved TAC logo asset is supplied. Do not redraw the logo.
class TacWordmark extends StatelessWidget {
  const TacWordmark({super.key, this.onDark = false, this.size = 44});

  final bool onDark;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'TAC',
      child: Text(
        'TAC',
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: onDark ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }
}
