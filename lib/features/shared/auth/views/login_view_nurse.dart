import 'package:marbella/features/shared/auth/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/password/views/forgot_password_view.dart';
import 'package:marbella/features/shared/settings/views/home_view.dart';
import 'package:marbella/features/shared/auth/views/verification/verification_required_view.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginViewNurse extends StatefulWidget {
  const LoginViewNurse({super.key});

  @override
  State<LoginViewNurse> createState() => _LoginViewNurseState();
}

class _LoginViewNurseState extends State<LoginViewNurse> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthViewmodel auth) async {
    if (!_formKey.currentState!.validate()) return;

    final locale = context.read<LocalizationViewmodel>().language;

    final params = LoginParams(
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
    );

    await auth.login(params, locale?.languageCode ?? 'en');

    if (!mounted) return;

    if (auth.response != null) {
      AppSnackbar.show(
        context,
        message: S.of(context).user_logged_in_success,
        type: SnackbarType.success,
      );

      auth.isVerified
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeView()),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    VerificationRequiredView(phone: _phoneController.text),
              ),
            );
    } else {
      if (auth.errorMessageLogIn != null && !auth.isPermanentlyLocked) {
        AppSnackbar.show(
          context,
          message: auth.errorMessageLogIn!,
          type: SnackbarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final auth = context.watch<AuthViewmodel>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBackground(color: colorScheme.primary),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1000.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24.h),
                      Center(
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withAlpha(
                                  (0.75 * 255).toInt(),
                                ),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withAlpha(
                                  (0.35 * 255).toInt(),
                                ),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        S().welcome,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        S().log_in,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(
                            (0.5 * 255).toInt(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              icon: Icons.phone_android_rounded,
                              hint: S().phone_hint,
                              text: S().phone_label,
                              controller: _phoneController,
                              minLength: 0,
                              isPhone: true,
                              isValidation: true,
                              maxLength: 10,
                              type: TextInputType.phone,
                            ),
                            SizedBox(height: 12.h),
                            CustomTextField(
                              icon: Icons.lock_outline_rounded,
                              hint: S().password_hint,
                              text: S().password_label,
                              type: TextInputType.visiblePassword,
                              controller: _passwordController,
                              isPassword: true,
                              minLength: 6,
                              isPhone: false,
                              isValidation: true,
                            ),
                            SizedBox(height: 4.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 6.h,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  S().forgot_password,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            CustomButtonWidget(
                              onPressed:
                                  auth.isLoadingLogIn ||
                                      auth.rateLimitSeconds > 0
                                  ? null
                                  : () => _handleLogin(auth),
                              height: 40.h,
                              width: double.infinity,
                              left: 0.w,
                              right: 0.w,
                              top: 0.h,
                              bottom: 0,
                              textSize: 16,
                              color: colorScheme.primary,
                              elevation: 4,
                              textColor: Colors.white,
                              child: auth.isLoadingLogIn
                                  ? const SpinKitThreeInOut(
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Text(
                                      S().log_in,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                            ),

                            if (auth.rateLimitSeconds > 0) ...[
                              SizedBox(height: 14.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withAlpha(
                                    (0.1 * 255).toInt(),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.timer_outlined,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        S().retry,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Colors.orange.shade800,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
