import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';

/// G · Google sign-in stub (the OAuth decision is still open).
class GoogleStubScreen extends StatelessWidget {
  const GoogleStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Continue with Google')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_clock_outlined, size: 64, color: AppColors.muted),
            Gap.h16,
            Text('Not configured in this demo', style: text.titleLarge, textAlign: TextAlign.center),
            Gap.h8,
            Text(
              'Google sign-in will be added once the team decides on OAuth. Use your phone number for now.',
              style: text.bodyMedium?.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
            Gap.h16,
            const DemoBadge(),
          ],
        ),
      ),
      bottomNavigationBar: BottomCta(
        children: [OutlinedButton(onPressed: () => context.pop(), child: const Text('Back'))],
      ),
    );
  }
}
