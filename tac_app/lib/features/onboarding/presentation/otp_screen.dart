import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/toast.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';

/// 04 · Verify OTP
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controller = TextEditingController();
  Timer? _timer;
  int _secondsLeft = AppConstants.otpResendSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = AppConstants.otpResendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) t.cancel();
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final phone = ref.watch(sessionProvider.select((s) => s.phone));
    final complete = _controller.text.length == AppConstants.otpLength;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          Text('Enter the code', style: text.headlineSmall),
          Gap.h8,
          Row(
            children: [
              Flexible(
                child: Text('Sent to $phone', style: text.bodyLarge?.copyWith(color: AppColors.muted)),
              ),
              TextButton(onPressed: () => context.pop(), child: const Text('Change')),
            ],
          ),
          Gap.h16,
          _OtpBoxes(controller: _controller, onChanged: () => setState(() {})),
          Gap.h16,
          Center(
            child: _secondsLeft > 0
                ? Text('Resend code in 0:${_secondsLeft.toString().padLeft(2, '0')}', style: text.bodySmall)
                : TextButton(
                    onPressed: () {
                      showToast('Demo: no SMS is sent.');
                      _startTimer();
                    },
                    child: const Text('Resend code'),
                  ),
          ),
          Gap.h16,
          const DemoNote('Demo: enter any 4 digits. Nothing is verified.'),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [PrimaryButton(label: 'Verify', onPressed: complete ? () => context.push(AppRoutes.details) : null)],
      ),
    );
  }
}

/// A hidden text field drawn as separate digit boxes. Keeps paste and SMS autofill working.
class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final value = controller.text;
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSizes.s12,
          children: [
            for (var i = 0; i < AppConstants.otpLength; i++)
              Container(
                width: 60,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                  border: Border.all(
                    color: i == value.length ? AppColors.primary : AppColors.line,
                    width: i == value.length ? 1.5 : 1,
                  ),
                ),
                child: Text(i < value.length ? value[i] : '', style: Theme.of(context).textTheme.headlineSmall),
              ),
          ],
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: controller,
              autofocus: true,
              showCursor: false,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(AppConstants.otpLength),
              ],
              decoration: const InputDecoration(border: InputBorder.none, filled: false),
              onChanged: (_) => onChanged(),
            ),
          ),
        ),
      ],
    );
  }
}
