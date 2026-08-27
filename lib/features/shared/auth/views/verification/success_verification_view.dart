import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/settings/views/home_view.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/generated/l10n.dart';

class SuccessVerificationView extends StatefulWidget {
  const SuccessVerificationView({super.key});

  @override
  State<SuccessVerificationView> createState() => _SuccessState();
}

class _SuccessState extends State<SuccessVerificationView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool isMobile = DeviceInfo.isMobile(context);
    bool isArabic = LocalizationViewmodel.isArabic();

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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/config.png',
                    width: isMobile ? 600.w : 500.w,
                    height: isMobile ? 300.h : 400.h,
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
                    S().verified,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  CustomButtonWidget(
                    onPressed: () async {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HomeView();
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
                      S().go_to_home_page,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
