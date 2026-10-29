import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';

/// 06b · Manual address
class ManualAddressScreen extends ConsumerStatefulWidget {
  const ManualAddressScreen({super.key});

  @override
  ConsumerState<ManualAddressScreen> createState() => _ManualAddressScreenState();
}

class _ManualAddressScreenState extends ConsumerState<ManualAddressScreen> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(sessionProvider.notifier).completeOnboarding(area: _controller.text.trim());
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Enter your address')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.fullStreetAddress],
            decoration: const InputDecoration(
              labelText: 'Area, town or Eircode',
              hintText: 'e.g. Rathmines, Dublin 6',
              prefixIcon: Icon(Icons.home_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [PrimaryButton(label: 'Save', loading: _saving, onPressed: hasText ? _save : null)],
      ),
    );
  }
}
