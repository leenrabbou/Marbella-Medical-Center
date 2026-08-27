import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/password/viewmodels/password_viewmodel.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/password/views/successful_view.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key, required this.phone, required this.otp});
  final String phone, otp;

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String confirmMsg = S().field_is_required;

  late String locale;
  String? token;
  ResetPasswordParams? params;
  void onPressed() async {
    if (formKey.currentState!.validate()) {
      if (_passwordController.text.length < 8) {
        AppSnackbar.show(context, message: S().password_too_short);
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          AppSnackbar.show(context, message: S().passwords_do_not_match);
          confirmMsg = S().passwords_do_not_match;
          formKey.currentState!.validate();
        });
        return;
      }
      params = ResetPasswordParams(
        phoneNumber: widget.phone,
        otp: widget.otp,
        password: _passwordController.text,
      );
      locale = Localizations.localeOf(context).languageCode;
      token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      final passwordProvider = context.read<PasswordViewmodel>();
      await passwordProvider.resetPassword(params!, locale);

      if (passwordProvider.resetPasswordSuccessfully) {
        AppSnackbar.show(
          context,
          message: S.of(context).reset_password_successfully,
          type: SnackbarType.success,
        );
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SuccessfulView();
            },
          ),
        );
      } else {
        AppSnackbar.show(
          context,
          message: passwordProvider.errorMessageResetPassword ?? S().error,
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isMobile
              ? SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/SetNewPassword.png',
                          width: 1000.w,
                          height: 350.h,
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
                          Center(
                            child: Image.asset(
                              'assets/SetNewPassword.png',
                              width: 500.w,
                              height: 500.h,
                            ),
                          ),
                          SizedBox(width: 30.w),
                          _buildForm(context),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    bool isMobile = DeviceInfo.isMobile(context);

    final passwordProvider = context.watch<PasswordViewmodel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S().set_new_password,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          S().must_be_at_least_8_characters,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: isMobile ? 10.h : 20.h),
        CustomTextField(
          text: S().new_password,
          hint: S().enter_new_password,
          controller: _passwordController,
          width: isMobile ? 850.w : 500.w,
          height: isMobile ? 75.h : 100.h,
          left: 20.w,
          right: 20.w,
          top: 0,
          bottom: 0,
          errorMsg: S().field_is_required,
          prefix: Icon(Icons.lock, color: colorScheme.primary),
          inputFormatter: null,
          isPassword: true,
          maxLength: null,
          isPhone: false,
          isValidation: true,
        ),
        CustomTextField(
          hint: S().confirm_password,
          text: S().password_label,
          controller: _confirmPasswordController,
          width: isMobile ? 850.w : 500.w,
          height: isMobile ? 75.h : 110.h,
          left: 20.w,
          right: 20.w,
          top: 0,
          bottom: 0,
          errorMsg: confirmMsg,
          prefix: Icon(Icons.lock, color: colorScheme.primary),
          inputFormatter: null,
          isPassword: true,
          maxLength: null,
          isPhone: false,
          isValidation: true,
        ),
        CustomButtonWidget(
          onPressed: passwordProvider.isLoadingResetPassword ? null : onPressed,
          height: 50,
          width: isMobile ? 500.w : 300.w,
          left: 30.w,
          right: 30.w,
          top: 5.h,
          bottom: 0,
          textSize: 18,
          color: colorScheme.primary,
          elevation: 3,
          textColor: Colors.white,
          child: passwordProvider.isLoadingResetPassword
              ? SpinKitThreeInOut(
                  color: Theme.of(context).colorScheme.surface,
                  size: 20,
                )
              : Text(
                  S().reset_password,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
