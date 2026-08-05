import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/password/views/forgot_password_view.dart';
import 'package:marbella/features/shared/settings/views/home_view.dart';
import 'package:marbella/features/shared/settings/views/onboarding_view.dart';
import 'package:marbella/features/shared/auth/views/verification/verification_required_view.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginViewDoctor extends StatefulWidget {
  const LoginViewDoctor({super.key});

  @override
  State<LoginViewDoctor> createState() => _LoginViewDoctorState();
}

class _LoginViewDoctorState extends State<LoginViewDoctor> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceInfo.isMobile(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: isMobile
            ? EdgeInsets.symmetric(horizontal: 50.w, vertical: 40.h)
            : EdgeInsets.all(10),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Image.asset(
                    'assets/h (6).png',
                    width: 900.w,
                    height: 190.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 25.h),
                  _buildForm(context),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 120.h,
                  horizontal: 50.w,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildForm(context)),
                    SizedBox(width: 50.w),
                    ClipRRect(
                      child: Image.asset(
                        'assets/h (6).png',
                        height: 350.h,
                        width: 450.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final auth = context.watch<AuthViewmodel>();
    bool isMobile = DeviceInfo.isMobile(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 700.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile
                ? SizedBox.shrink()
                : Row(
                    children: [
                      Image.asset(
                        "assets/imglogo1.png",
                        height: 35.h,
                        width: 35.w,
                      ),
                      Text(
                        'arbella',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'AlexBrush',
                            ),
                      ),
                    ],
                  ),
            SizedBox(height: isMobile ? 5.h : 30.h),
            Text(
              S().welcome,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: isMobile ? 15.h : 10.h),
            CustomTextField(
              icon: Icons.phone_android_rounded,
              hint: S().phone_hint,
              text: S().phone_label,
              controller: phoneController,
              minLength: 0,
              isPhone: true,
              isValidation: true,
              maxLength: 10,
              type: TextInputType.phone,
            ),
            SizedBox(height: 15.h),
            CustomTextField(
              icon: Icons.password,
              hint: S().password_hint,
              text: S().password_label,
              type: TextInputType.visiblePassword,
              controller: passwordController,
              isPassword: true,
              minLength: 6,
              isPhone: false,
              isValidation: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const ForgotPasswordView();
                      },
                    ),
                  );
                },
                child: Text(
                  S().forgot_password,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 5.h : 10.h),

            CustomButtonWidget(
              onPressed: auth.isLoadingLogIn || auth.rateLimitSeconds > 0
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        bool? val = CacheService().getData(
                          key: CacheKeys.onBoarding,
                        );
                        final locale = context
                            .read<LocalizationViewmodel>()
                            .language;

                        final params = LoginParams(
                          phoneNumber: phoneController.text,
                          password: passwordController.text,
                        );

                        await auth.login(params, locale!.languageCode);
                        if (auth.response != null) {
                          AppSnackbar.show(
                            context,
                            message: S.of(context).user_logged_in_success,
                            type: SnackbarType.success,
                          );

                          auth.isVerified
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => val == true
                                        ? HomeView()
                                        : OnboardingView(),
                                  ),
                                )
                              : Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VerificationRequiredView(
                                      phone: phoneController.text,
                                    ),
                                  ),
                                );
                        } else {
                          if (auth.errorMessageLogIn != null &&
                              !auth.isPermanentlyLocked) {
                            AppSnackbar.show(
                              context,
                              message: auth.errorMessageLogIn!,
                              type: SnackbarType.error,
                            );
                          }
                        }
                      }
                    },
              height: isMobile ? 30.h : 45.h,
              width: double.infinity,
              left: 0.w,
              right: 0.w,
              top: 0.h,
              bottom: 0,
              textSize: 18,
              color: colorScheme.primary,
              elevation: 3,
              textColor: Colors.white,
              child: auth.isLoadingLogIn
                  ? const SpinKitThreeInOut(color: Colors.white, size: 20)
                  : Text(
                      S().log_in,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
