import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';

/// 01 · Splash
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const _benefits = [
    (Icons.euro_rounded, 'Save money on every trip'),
    (Icons.people_alt_outlined, 'Meet people going your way'),
    (Icons.eco_outlined, 'Cut emissions together'),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(alignment: Alignment.topRight, child: DemoBadge(onDark: true)),
                const Spacer(),
                const TacWordmark(onDark: true, size: 56),
                Gap.h12,
                Text(AppStrings.tagline, style: text.headlineSmall?.copyWith(color: Colors.white)),
                Gap.h32,
                for (final (icon, label) in _benefits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.s12),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white, size: 22),
                        Gap.w12,
                        Text(label, style: text.bodyLarge?.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: () => context.push(AppRoutes.welcome),
                  style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primaryDark),
                  child: const Text('Get started'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
