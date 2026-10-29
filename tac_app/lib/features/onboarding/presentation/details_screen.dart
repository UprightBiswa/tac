import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';

/// 05 · Your details
class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({super.key});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  String? _required(String? value) => (value ?? '').trim().isEmpty ? 'Required' : null;

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(sessionProvider.notifier).setName(_first.text, _last.text);
    context.push(AppRoutes.location);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
            children: [
              Text('Your details', style: text.headlineSmall),
              Gap.h8,
              Text('Drivers and riders see your first name.', style: text.bodyLarge?.copyWith(color: AppColors.muted)),
              Gap.h24,
              TextFormField(
                controller: _first,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.givenName],
                decoration: const InputDecoration(labelText: 'First name'),
                validator: _required,
              ),
              Gap.h16,
              TextFormField(
                controller: _last,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.familyName],
                decoration: const InputDecoration(labelText: 'Last name'),
                validator: _required,
                onFieldSubmitted: (_) => _continue(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomCta(
        children: [PrimaryButton(label: 'Continue', onPressed: _continue)],
      ),
    );
  }
}
