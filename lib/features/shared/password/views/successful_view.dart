import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/auth/views/login_view.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/generated/l10n.dart';

class SuccessfulView extends StatelessWidget {
  const SuccessfulView({super.key});
  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationViewmodel.isArabic();
    bool isMobile = DeviceInfo.isMobile(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/checked.png',
                        width: isMobile ? 400.w : 200.w,
                        height: isMobile ? 400.w : 200.h,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        S().all_done,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        S().reset_successfully,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomButtonWidget(
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const LoginView();
                              },
                            ),
                          );
                        },
                        height: 50,
                        width: 500.w,
                        left: 30.w,
                        right: 30.w,
                        top: 5.h,
                        bottom: 0,
                        textSize: 18,
                        color: colorScheme.primary,
                        elevation: 3,
                        textColor: Colors.white,
                        child: Text(
                          S().go_to_login_page,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
