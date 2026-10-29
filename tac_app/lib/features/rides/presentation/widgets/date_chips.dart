import 'package:flutter/material.dart';

import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';

/// Today · Tomorrow · Pick a date. Shared by the rider search and driver offer screens.
class DateChips extends StatelessWidget {
  const DateChips({super.key, required this.selected, required this.onSelected});

  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final today = dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final isCustom = selected != today && selected != tomorrow;

    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      children: [
        ChoiceChip(label: const Text('Today'), selected: selected == today, onSelected: (_) => onSelected(today)),
        ChoiceChip(
          label: const Text('Tomorrow'),
          selected: selected == tomorrow,
          onSelected: (_) => onSelected(tomorrow),
        ),
        ChoiceChip(
          avatar: const Icon(Icons.calendar_today, size: 16),
          label: Text(isCustom ? formatDay(selected) : 'Pick a date'),
          selected: isCustom,
          onSelected: (_) async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selected,
              firstDate: today,
              lastDate: today.add(const Duration(days: 60)),
            );
            if (picked != null) onSelected(picked);
          },
        ),
      ],
    );
  }
}
