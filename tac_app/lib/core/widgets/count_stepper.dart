import 'package:flutter/material.dart';

import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';

/// "Seats  (−) 2 (+)" control. [format] renders the value (defaults to the number).
class CountStepper extends StatelessWidget {
  const CountStepper({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.format,
    this.caption,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;
  final String Function(int value)? format;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.titleSmall),
              if (caption != null) Text(caption!, style: text.bodySmall),
            ],
          ),
        ),
        _RoundButton(
          icon: Icons.remove,
          tooltip: 'Decrease $label',
          onPressed: value - step >= min ? () => onChanged(value - step) : null,
        ),
        SizedBox(
          width: 64,
          child: Text(format?.call(value) ?? '$value', textAlign: TextAlign.center, style: text.titleLarge),
        ),
        _RoundButton(
          icon: Icons.add,
          tooltip: 'Increase $label',
          onPressed: value + step <= max ? () => onChanged(value + step) : null,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      color: AppColors.navy,
      constraints: const BoxConstraints.tightFor(width: AppSizes.minTouch, height: AppSizes.minTouch),
      style: IconButton.styleFrom(side: const BorderSide(color: AppColors.line)),
    );
  }
}
