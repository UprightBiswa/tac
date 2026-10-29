import 'package:flutter/material.dart';

import 'package:tac_app/core/constants/app_sizes.dart';

/// Sticky bottom action area for `Scaffold.bottomNavigationBar`.
/// It lifts above the keyboard so the main button stays reachable.
class BottomCta extends StatelessWidget {
  const BottomCta({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding,
            AppSizes.s12,
            AppSizes.screenPadding,
            AppSizes.s16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.s8,
            children: children,
          ),
        ),
      ),
    );
  }
}
