import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/password/viewmodels/password_viewmodel.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/password/views/reset_password_view.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String locale;
  String? token;
  void onPressed() async {
    if (formKey.currentState!.validate()) {
      locale = Localizations.localeOf(context).languageCode;
      token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      final passwordProvider = context.read<PasswordViewmodel>();
      await passwordProvider.forgetPassword(_phoneController.text, locale);

      if (passwordProvider.forgetPasswordSuccessfully) {
        AppSnackbar.show(
          context,
          message: S.of(context).reset_code_sent_successfully,
          type: SnackbarType.success,
        );

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ResetPasswordView(phone: _phoneController.text);
            },
          ),
        );
      } else {
        AppSnackbar.show(
          context,
          message:
              passwordProvider.errorMessageForgetPassword ??
              S.of(context).error,
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
                          'assets/pass.png',
                          width: 1000.w,
                          height: 300.h,
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
                            'assets/pass.png',
                            width: 500.w,
                            height: 500.h,
                          ),
                          SizedBox(width: 80.w),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S().forgot_password,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          S().we_will_send_you_reset_instructions,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: isMobile ? 10.h : 45.h),
        CustomTextField(
          text: S().phone_label,
          hint: S().phone_hint,
          controller: _phoneController,
          width: isMobile ? 850.w : 500.w,
          height: isMobile ? 75.h : 110.h,
          errorMsg: S().field_is_required,
          type: TextInputType.phone,
          fillColor: null,
          prefix: Icon(Icons.phone_android, color: colorScheme.primary),
          maxLength: 10,
          isPhone: true,
          isValidation: true,
        ),
        CustomButtonWidget(
          onPressed: passwordProvider.isLoadingForgetPassword
              ? null
              : onPressed,
          height: 50,
          width: isMobile ? 500.w : 300.w,
          left: 30,
          right: 30,
          top: 5,
          bottom: 0,
          textSize: 18,
          color: colorScheme.primary,
          elevation: 3,
          textColor: Colors.white,
          child: passwordProvider.isLoadingForgetPassword
              ? SpinKitThreeInOut(
                  color: Theme.of(context).colorScheme.surface,
                  size: 20,
                )
              : Text(
                  S().reset_password,
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
