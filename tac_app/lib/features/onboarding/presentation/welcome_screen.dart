import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/map_preview.dart';
import 'package:tac_app/core/widgets/primary_button.dart';

/// 02 · Welcome
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          const MapPreview(height: 220, showRoute: true),
          Gap.h24,
          Text('Share the ride.\nA cleaner Ireland together.', style: text.headlineSmall),
          Gap.h16,
          const Wrap(
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: [
              TagPill(
                'Save money',
                icon: Icons.euro_rounded,
                color: AppColors.primaryDark,
                background: AppColors.primarySoft,
              ),
              TagPill(
                'Meet people',
                icon: Icons.people_alt_outlined,
                color: AppColors.navy,
                background: AppColors.line,
              ),
              TagPill('Reduce emissions', icon: Icons.eco_outlined),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [
          PrimaryButton(
            label: 'Continue with phone',
            icon: Icons.phone_iphone,
            onPressed: () => context.push(AppRoutes.phone),
          ),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.google),
            icon: const Icon(Icons.g_mobiledata, size: 28),
            label: const Text('Continue with Google'),
          ),
          Text(
            'By continuing you agree to the Terms and Privacy Policy.',
            textAlign: TextAlign.center,
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}
