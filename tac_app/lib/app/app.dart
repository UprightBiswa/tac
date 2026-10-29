import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/app/router/app_router.dart';
import 'package:tac_app/app/theme/app_theme.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/utils/toast.dart';

class TacApp extends ConsumerWidget {
  const TacApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(routerProvider),
      scaffoldMessengerKey: scaffoldMessengerKey,
      // Respect large-text settings, but cap them so fixed-height controls don't break.
      builder: (context, child) => MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3, child: child!),
    );
  }
}
