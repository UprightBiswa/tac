import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/env/env.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/features/booking/application/booking_providers.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';
import 'package:tac_app/features/rides/application/rides_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _restart(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart demo?'),
        content: const Text('This clears your name, bookings and search, and goes back to the splash screen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Restart')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(sessionProvider.notifier).reset();
    ref
      ..invalidate(myBookingsProvider)
      ..invalidate(rideSearchProvider);
    if (context.mounted) context.go(AppRoutes.splash);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final session = ref.watch(sessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          SectionCard(
            child: Row(
              children: [
                InitialsAvatar(session.initials, size: 56),
                Gap.w16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.fullName, style: text.titleLarge),
                      if (session.phone.isNotEmpty) Text(session.phone, style: text.bodySmall),
                      Text(session.area, style: text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap.h12,
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.science_outlined, color: AppColors.primary),
                  title: Text('Demo build'),
                  subtitle: Text('Mock data only. OTP, location, payments and chat are simulated.'),
                ),
                const Divider(indent: 56),
                const ListTile(
                  leading: Icon(Icons.tune, color: AppColors.muted),
                  title: Text('Environment'),
                  subtitle: Text('${Env.flavor} · ${Env.useMockData ? 'mock data' : Env.apiBaseUrl}'),
                ),
                const Divider(indent: 56),
                ListTile(
                  leading: const Icon(Icons.restart_alt, color: AppColors.error),
                  title: const Text('Restart demo', style: TextStyle(color: AppColors.error)),
                  onTap: () => _restart(context, ref),
                ),
              ],
            ),
          ),
          Gap.h16,
          const Center(child: DemoBadge()),
        ],
      ),
    );
  }
}
