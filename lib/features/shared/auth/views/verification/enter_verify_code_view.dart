import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/auth/viewmodels/verification_viewmodel.dart';
import 'package:marbella/features/shared/auth/views/verification/success_verification_view.dart';
import 'package:marbella/features/shared/auth/widgets/code_text_field.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class EnterVerifyCodeView extends StatefulWidget {
  const EnterVerifyCodeView({super.key, required this.phone});
  final String phone;

  @override
  State<EnterVerifyCodeView> createState() => _EnterVerifyCodeViewState();
}

class _EnterVerifyCodeViewState extends State<EnterVerifyCodeView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController code1Controller = TextEditingController();
  final TextEditingController code2Controller = TextEditingController();
  final TextEditingController code3Controller = TextEditingController();
  final TextEditingController code4Controller = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  late String locale;
  String? token;
  void onPressed() async {
    if (formKey.currentState!.validate()) {
      String otp =
          code1Controller.text +
          code2Controller.text +
          code3Controller.text +
          code4Controller.text;
      final auth = context.read<AuthViewmodel>();
      locale = Localizations.localeOf(context).languageCode;
      token = auth.response?.data?.token ?? auth.userFromCache?.data?.token;
      final verificationProvider = context.read<VerificationViewmodel>();
      await verificationProvider.verifyPhone(otp, locale, token);

      if (verificationProvider.verifySuccessfully) {
        auth.markUserAsVerified();

        AppSnackbar.show(
          context,
          message: S.of(context).verification_successful,
          type: SnackbarType.success,
        );
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SuccessVerificationView();
            },
          ),
        );
      } else {
        AppSnackbar.show(
          context,
          message:
              verificationProvider.errorMessageVerify ?? S.of(context).error,
          type: SnackbarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationViewmodel.isArabic();
    bool isMobile = DeviceInfo.isMobile(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            isArabic ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: isMobile
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/verifyEmail.png',
                        width: 1000.w,
                        height: 300.h,
                      ),
                      _buildForm(context),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/verifyEmail.png',
                      width: 550.w,
                      height: 550.h,
                    ),
                    SizedBox(width: 30.w),
                    _buildForm(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    bool isMobile = DeviceInfo.isMobile(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final verificationProvider = context.read<VerificationViewmodel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S().verify_your_account,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          S().enter_code_sent_to_whatsapp,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        Text(
          widget.phone,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CodeTextField(textController: code1Controller, isLast: false),
            SizedBox(width: 15.w),
            CodeTextField(textController: code2Controller, isLast: false),
            SizedBox(width: 15.w),
            CodeTextField(textController: code3Controller, isLast: false),
            SizedBox(width: 15.w),
            CodeTextField(textController: code4Controller, isLast: false),
          ],
        ),
        Center(
          child: TextButton(
            onPressed: _canResend
                ? () async {
                    final auth = context.read<AuthViewmodel>();
                    final locale = Localizations.localeOf(context).languageCode;
                    final token =
                        auth.response?.data?.token ??
                        auth.userFromCache?.data?.token;
                    await context
                        .read<VerificationViewmodel>()
                        .getVerificationCode(locale, token);
                    _startTimer();
                  }
                : null,
            child: _canResend
                ? Text(
                    S().resend_code,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "${S().resend_code} ($_remainingSeconds${S.of(context).sec})",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        CustomButtonWidget(
          onPressed: verificationProvider.isLoadingVerify ? null : onPressed,
          height: 50,
          width: isMobile ? 500.w : 300.w,
          left: 30.w,
          right: 30.w,
          top: isMobile ? 0 : 10.h,
          bottom: 0,
          textSize: 18,
          color: colorScheme.primary,
          elevation: 3,
          textColor: Colors.white,
          child: verificationProvider.isLoadingVerify
              ? SpinKitThreeInOut(
                  color: Theme.of(context).colorScheme.surface,
                  size: 20,
                )
              : Text(
                  S().confirm,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
