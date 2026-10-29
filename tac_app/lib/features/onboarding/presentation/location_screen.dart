import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/core/widgets/map_preview.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';

/// 06 · Location
class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  bool _saving = false;

  Future<void> _allow() async {
    setState(() => _saving = true);
    await ref.read(sessionProvider.notifier).completeOnboarding(area: 'Dublin 2');
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          const MapPreview(height: 220, label: 'Dublin 2'),
          Gap.h24,
          Text('Find rides near you', style: text.headlineSmall),
          Gap.h8,
          Text(
            'Turn on location so we can show rides that start close to you.',
            style: text.bodyLarge?.copyWith(color: AppColors.muted),
          ),
          Gap.h16,
          const DemoNote('Demo: your location is set to Dublin 2. GPS is not used.'),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [
          PrimaryButton(label: 'Turn on location', icon: Icons.my_location, loading: _saving, onPressed: _allow),
          TextButton(
            onPressed: () => context.push(AppRoutes.manualAddress),
            child: const Text('Enter address manually'),
          ),
        ],
      ),
    );
  }
}
