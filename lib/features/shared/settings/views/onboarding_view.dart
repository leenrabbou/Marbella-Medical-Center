import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/settings/models/intro_model.dart';
import 'package:marbella/features/shared/settings/views/home_view.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  bool onLastPage = false;
  List<IntroModel> introScreens = [
    IntroModel(
      id: 1,
      title: S().efficient_patient_management,
      text: S().manage_your_patient_records_and_daily_clinic_schedule_with_ease,
      img: 'assets/pic_1.png',
    ),
    IntroModel(
      id: 2,
      title: S().instant_medical_support,
      text: S().our_technical_support_team_is_always_ready_to_assist_you,
      img: 'assets/pic_1 (3).png',
    ),
    IntroModel(
      id: 3,
      title: S().prescribe_anywhere,
      text:
          S().issue_digital_prescriptions_and_track_medical_history_with_just_a,
      img: 'assets/pic_1 (4).png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceInfo.isMobile(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  index == 2 ? onLastPage = true : onLastPage = false;
                });
              },
              controller: _pageController,
              itemBuilder: (context, index) {
                return buildIntro(
                  context,
                  id: introScreens[index].id,
                  image: introScreens[index].img,
                  title: introScreens[index].title,
                  description: introScreens[index].text,
                );
              },
              itemCount: introScreens.length,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SmoothPageIndicator(
              effect: ExpandingDotsEffect(activeDotColor: colorScheme.primary),
              controller: _pageController,
              count: 3,
            ),
          ),
          SizedBox(height: 25.h),
          onLastPage
              ? CustomButtonWidget(
                  onPressed: () async {
                    await CacheService().saveData(
                      key: CacheKeys.onBoarding,
                      value: true,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return HomeView();
                        },
                      ),
                    );
                  },
                  height: 40.h,
                  width: isMobile ? 400.w : 300.w,
                  left: 0.w,
                  right: 0.w,
                  top: 0.h,
                  bottom: 0,
                  textSize: 18,
                  color: colorScheme.primary,
                  elevation: 3,
                  textColor: Colors.white,
                  child: Text(
                    S.of(context).get_started,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(2);
                      },
                      child: Text(
                        S.of(context).skip,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomButtonWidget(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      height: 35.h,
                      width: isMobile ? 140.w : 100.w,
                      left: 0.w,
                      right: 0.w,
                      top: 0.h,
                      bottom: 0,
                      textSize: 18,
                      color: colorScheme.primary,
                      elevation: 3,
                      textColor: Colors.white,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 120.h),
        ],
      ),
    );
  }
}

Widget buildIntro(
  BuildContext context, {
  required int id,
  required String image,
  required String title,
  required String description,
}) {
  bool isMobile = DeviceInfo.isMobile(context);
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        image,
        height: isMobile ? 250.h : 300.h,
        width: isMobile ? 750.w : 600.w,
      ),
      SizedBox(height: 25.h),
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5.h),
      Text(
        textAlign: TextAlign.center,
        description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
      ),
    ],
  );
}
