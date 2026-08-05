import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/password/viewmodels/password_viewmodel.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String confirmMsg = S().field_is_required;
  late String locale;
  String? token;
  ChangePasswordParams? params;
  void onPressed() async {
    params = ChangePasswordParams(
      oldPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    if (formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        locale = Localizations.localeOf(context).languageCode;
        token =
            context.read<AuthViewmodel>().response?.data?.token ??
            context.read<AuthViewmodel>().userFromCache?.data?.token;
        final passwordProvider = context.read<PasswordViewmodel>();
        await passwordProvider.changePassword(params!, locale, token);

        if (passwordProvider.changePasswordSuccessfully) {
          AppSnackbar.show(
            context,
            message: S.of(context).your_password_changed_successfully,
            type: SnackbarType.success,
          );
          Navigator.pop(context);
        } else {
          AppSnackbar.show(
            context,
            message: passwordProvider.errorMessageChangePassword ?? S().error,
            type: SnackbarType.error,
          );
        }
      } else if (_newPasswordController.text !=
          _confirmPasswordController.text) {
        setState(() {
          AppSnackbar.show(context, message: S().passwords_do_not_match);
          confirmMsg = S().passwords_do_not_match;
          formKey.currentState!.validate();
        });
      } else if (_currentPasswordController.text ==
          _newPasswordController.text) {
        AppSnackbar.show(context, message: S.of(context).password_same_as_old);
        return;
      } else if (_newPasswordController.text.length < 8) {
        AppSnackbar.show(context, message: S().password_too_short);
        return;
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
                          'assets/change_passord.png',
                          width: 500.w,
                          height: 200.h,
                        ),
                        _buildForm(context),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 100.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/change_passord.png',
                              width: 350.w,
                              height: 350.h,
                            ),
                          ),
                          SizedBox(width: 50.w),
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
    final passwordProvider = context.watch<PasswordViewmodel>();

    bool isMobile = DeviceInfo.isMobile(context);
    return Column(
      children: [
        Text(
          S.of(context).change_your_password,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: colorScheme.primary),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          text: S.of(context).current_password,
          hint: S.of(context).enter_current_password,
          controller: _currentPasswordController,
          width: isMobile ? 850.w : 500.w,
          height: isMobile ? 60.h : 90.h,
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
          text: S().new_password,
          hint: S().enter_new_password,
          controller: _newPasswordController,
          width: isMobile ? 850.w : 500.w,
          height: isMobile ? 60.h : 90.h,
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
          height: isMobile ? 65.h : 100.h,
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
          onPressed: passwordProvider.isLoadingChangePassword
              ? () {}
              : onPressed,
          height: isMobile ? 30.h : 40.h,
          width: isMobile ? 400.w : 250.w,
          left: 30.w,
          right: 30.w,
          top: 5.h,
          bottom: 0,
          textSize: 18,
          color: colorScheme.primary,
          elevation: 3,
          textColor: Colors.white,
          child: passwordProvider.isLoadingChangePassword
              ? SpinKitThreeInOut(
                  color: Theme.of(context).colorScheme.surface,
                  size: 20,
                )
              : Text(
                  S().change_password,
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
