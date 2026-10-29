import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';

/// 03 · Phone number
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _controller = TextEditingController();

  bool get _valid => _controller.text.length >= AppConstants.minPhoneDigits;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    ref.read(sessionProvider.notifier).setPhone('+353 ${_controller.text}');
    context.push(AppRoutes.otp);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          Text("What's your number?", style: text.headlineSmall),
          Gap.h8,
          Text("We'll text you a code to confirm it.", style: text.bodyLarge?.copyWith(color: AppColors.muted)),
          Gap.h24,
          Row(
            children: [
              Container(
                height: AppSizes.inputHeight + 4,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                ),
                child: Text('🇮🇪  +353', style: text.titleSmall),
              ),
              Gap.w8,
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(AppConstants.maxPhoneDigits),
                  ],
                  decoration: const InputDecoration(hintText: '87 123 4567'),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _valid ? _continue() : null,
                ),
              ),
            ],
          ),
          Gap.h16,
          const DemoNote('Demo: no SMS is sent. Any number with 7+ digits works.'),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [PrimaryButton(label: 'Continue', onPressed: _valid ? _continue : null)],
      ),
    );
  }
}
