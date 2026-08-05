import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/auth/viewmodels/verification_viewmodel.dart';
import 'package:marbella/features/shared/auth/views/verification/enter_verify_code_view.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class VerificationRequiredView extends StatefulWidget {
  const VerificationRequiredView({super.key, required this.phone});
  final String phone;

  @override
  State<VerificationRequiredView> createState() =>
      _VerificationRequiredViewState();
}

class _VerificationRequiredViewState extends State<VerificationRequiredView> {
  bool isLoading = false;
  late String locale;
  String? token;
  void onPressed() async {
    locale = Localizations.localeOf(context).languageCode;
    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    final verificationProvider = context.read<VerificationViewmodel>();
    await verificationProvider.getVerificationCode(locale, token);

    if (verificationProvider.getCodeSuccessfully) {
      AppSnackbar.show(
        context,
        message: S.of(context).code_sent_successfully,
        type: SnackbarType.success,
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return EnterVerifyCodeView(phone: widget.phone);
          },
        ),
      );
    } else {
      AppSnackbar.show(
        context,
        message: verificationProvider.errorMessageGetCode ?? S().error,
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceInfo.isMobile(context);
    return Scaffold(
      appBar: AppBar(leading: null),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isMobile
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/ver1.png',
                      width: 1000.w,
                      height: 300.h,
                    ),
                    const SizedBox(height: 10),
                    _buildForm(context),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/ver1.png', width: 500.w, height: 500.h),
                  const SizedBox(width: 30),
                  _buildForm(context),
                ],
              ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool isMobile = DeviceInfo.isMobile(context);

    final verificationProvider = context.watch<VerificationViewmodel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S().verification_required,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          S().your_phone_number_is_not_verified,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        Text(
          S().please_verify_your_account,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
        CustomButtonWidget(
          onPressed: verificationProvider.isLoadingGetCode ? null : onPressed,
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
          child: verificationProvider.isLoadingGetCode
              ? SpinKitThreeInOut(
                  color: Theme.of(context).colorScheme.surface,
                  size: 20,
                )
              : Text(
                  S().get_verification_code,
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
