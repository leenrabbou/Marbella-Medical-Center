import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/views/certificates_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/profile/viewmodels/profile_viewmodel.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/profile/widgets/profile_container_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String locale;
  String? token;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    locale = Localizations.localeOf(context).languageCode;
    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;
    await context.read<ProfileViewmodel>().getProfile(locale, token);
  }

  Future<void> _handleRefresh() async {
    await _loadProfile();
  }

  String safeText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final profileProvider = context.watch<ProfileViewmodel>();
    final profile = profileProvider.profileData;
    final role = context.read<AppRole>();
    bool isMobile = DeviceInfo.isMobile(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).profile),
        actions: [
          if (role == AppRole.doctor)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CertificatesView()),
                );
              },
              icon: Icon(Icons.workspace_premium_rounded),
            ),
        ],
      ),
      body: LiquidPullToRefresh(
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        onRefresh: _handleRefresh,
        child: Center(
          child: StateWidget(
            isLoading:
                profileProvider.isLoading &&
                profileProvider.profileData == null,
            error: profileProvider.errorMessage,
            isEmpty:
                !profileProvider.isLoading &&
                profileProvider.errorMessage == null &&
                profile == null,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: profile == null
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [SizedBox(height: 500)],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 30.w : 0.w,
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          _buildHeader(context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              children: [
                                SizedBox(height: isMobile ? 8.h : 12.h),
                                _buildSectionTitle(
                                  context,
                                  S().professional_info,
                                ),
                                ProfileContainerWidget(
                                  title: S().specialization,
                                  text: safeText(profile.specialization),
                                  icon: Icons.work_outline_rounded,
                                ),
                                ProfileContainerWidget(
                                  title: S().experiences,
                                  text: safeText(profile.experiences),
                                  icon: Icons.history_edu_outlined,
                                ),
                                SizedBox(height: isMobile ? 8.h : 12.h),
                                _buildSectionTitle(context, S().personal_data),
                                ProfileContainerWidget(
                                  title: S().phone_label,
                                  text: safeText(profile.phoneNumber),
                                  icon: Icons.phone_android_outlined,
                                ),
                                ProfileContainerWidget(
                                  title: S().birth_date,
                                  text:
                                      "${Constant.formatDate(context, profile.birthDate)} "
                                      "(${profile.age} ${S().years_old})",
                                  icon: Icons.cake_outlined,
                                ),
                                ProfileContainerWidget(
                                  title: S().ssn,
                                  text: safeText(profile.ssn),
                                  icon: Icons.badge_outlined,
                                ),
                                ProfileContainerWidget(
                                  title: S().address,
                                  text: safeText(profile.address),
                                  icon: Icons.location_on_outlined,
                                ),
                                SizedBox(height: isMobile ? 8.h : 12.h),
                                _buildSectionTitle(context, S().social_status),
                                ProfileContainerWidget(
                                  title: S().marital_status,
                                  text: safeText(profile.maritalStatus),
                                  icon: Icons.favorite_outline_rounded,
                                ),
                                ProfileContainerWidget(
                                  title: S().social_history,
                                  text: safeText(profile.socialHistory),
                                  icon: Icons.article_outlined,
                                ),
                                SizedBox(height: isMobile ? 10.h : 20.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final profileProvider = context.watch<ProfileViewmodel>();
    Color avatarColor = profileProvider.profileData == null
        ? Theme.of(context).colorScheme.primary
        : Constant.listColors[(profileProvider.profileData!.firstName.length +
                  profileProvider.profileData!.lastName.length) %
              Constant.listColors.length];
    bool isMobile = DeviceInfo.isMobile(context);
    return Column(
      children: [
        AppAvatar(
          size: isMobile ? 220.r : 100.r,
          fallbackAsset: profileProvider.profileData!.gender == "male"
              ? "assets/doc_male.png"
              : "assets/doc_female.png",
          color: avatarColor,
        ),
        SizedBox(height: isMobile ? 5.h : 10.h),
        Text(
          "${profileProvider.profileData!.firstName} ${profileProvider.profileData!.lastName}",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          profileProvider.profileData!.specialization,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    bool isMobile = DeviceInfo.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Container(
            width: isMobile ? 6.w : 4.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: isMobile ? 10.w : 8.w),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
