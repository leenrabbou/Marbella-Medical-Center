import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/password/viewmodels/password_viewmodel.dart';
import 'package:marbella/features/shared/password/views/new_password_view.dart';
import 'package:marbella/features/shared/auth/widgets/code_text_field.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key, required this.phone});
  final String phone;

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController code1Controller = TextEditingController();
  final TextEditingController code2Controller = TextEditingController();
  final TextEditingController code3Controller = TextEditingController();
  final TextEditingController code4Controller = TextEditingController();
  bool showText = false;
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
  CheckOtpParams? params;
  void onPressed() async {
    if (formKey.currentState!.validate()) {
      String otp =
          code1Controller.text +
          code2Controller.text +
          code3Controller.text +
          code4Controller.text;
      params = CheckOtpParams(phoneNumber: widget.phone, otp: otp);
      locale = Localizations.localeOf(context).languageCode;
      token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      final passwordProvider = context.read<PasswordViewmodel>();
      await passwordProvider.checkOtp(params!, locale);

      if (passwordProvider.checkOtpSuccessfully) {
        AppSnackbar.show(
          context,
          message: S.of(context).otp_is_valid,
          type: SnackbarType.success,
        );

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return NewPasswordView(phone: widget.phone, otp: otp);
            },
          ),
        );
      } else {
        AppSnackbar.show(
          context,
          message: passwordProvider.errorMessageCheckOtp ?? S().error,
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
      body: Form(
        key: formKey,
        child: isMobile
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Reset password-pana.png',
                        width: 1000.w,
                        height: 400.h,
                      ),
                      _buildForm(context),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Reset password-pana.png',
                          width: 600.w,
                          height: 500.h,
                        ),
                        SizedBox(width: 30.w),
                        _buildForm(context),
                      ],
                    ),
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

    final passwordProvider = context.watch<PasswordViewmodel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S().reset_password,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          S().enter_code_sent_to_whatsapp,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          widget.phone,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 25.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CodeTextField(textController: code1Controller, isLast: false),
            SizedBox(width: 15.w),
            CodeTextField(isLast: false, textController: code2Controller),
            SizedBox(width: 15.w),
            CodeTextField(textController: code3Controller, isLast: false),
            SizedBox(width: 15.w),
            CodeTextField(textController: code4Controller, isLast: false),
          ],
        ),
        SizedBox(height: 15.h),
        Center(
          child: TextButton(
            onPressed: _canResend
                ? () async {
                    final locale = Localizations.localeOf(context).languageCode;
                    await context.read<PasswordViewmodel>().forgetPassword(
                      widget.phone,
                      locale,
                    );
                    _startTimer();
                  }
                : null,
            child: _canResend
                ? Text(
                    S().resend_code,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  )
                : Text(
                    "${S().resend_code} (${_remainingSeconds}s)",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
          ),
        ),
        showText
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    top: 0,
                    bottom: 15,
                  ),
                  child: Text(
                    S().check_your_whatsapp,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                  ),
                ),
              )
            : SizedBox.shrink(),
        CustomButtonWidget(
          onPressed: passwordProvider.isLoadingCheckOtp ? null : onPressed,
          height: 50,
          width: isMobile ? 500.w : 300.w,
          left: 30,
          right: 30,
          top: 0,
          bottom: 0,
          textSize: 18,
          color: colorScheme.primary,
          elevation: 3,
          textColor: Colors.white,
          child: passwordProvider.isLoadingCheckOtp
              ? SpinKitThreeInOut(
                  color: Theme.of(context).colorScheme.surface,
                  size: 20,
                )
              : Text(
                  S().continue_button,
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
