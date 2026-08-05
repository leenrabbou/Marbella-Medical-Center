import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/nurses/widgets/nurse_dialogs.dart';
import 'package:marbella/features/shared/profile/models/user_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NurseDetailsView extends StatelessWidget {
  const NurseDetailsView({
    super.key,
    required this.nurse,
    required this.encounterId,
    this.isEditable = false,
  });

  final EmployeeModel nurse;
  final int encounterId;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasExperiences = nurse.experiences == null ? false : true;
    final hasAddress = nurse.address == null ? false : true;
    final hasSocialHistory = nurse.socialHistory == null ? false : true;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 15),
        ),
        title: const SizedBox.shrink(),
        actions: [
          if (isEditable)
            IconButton(
              onPressed: () =>
                  NurseDialogs.showDeleteDialog(context, encounterId, nurse.id),
              icon: const Icon(
                Icons.person_remove_outlined,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
          SizedBox(width: 4.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: StyleWidget.cardDecoration(context),
                child: Column(
                  children: [
                    AppAvatar(
                      size: 80.w,
                      imageUrl: nurse.image?.url,
                      initials:
                          '${nurse.firstName.isNotEmpty ? nurse.firstName[0] : ''}${nurse.lastName.isNotEmpty ? nurse.lastName[0] : ''}'
                              .toUpperCase(),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '${nurse.firstName} ${nurse.lastName}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(
                          (0.1 * 255).toInt(),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        nurse.specialization,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),

            _sectionCard(
              context,
              title: S().contact_information,
              children: [
                _detailRow(
                  context,
                  icon: Icons.phone_outlined,
                  label: S().phone_label,
                  value: nurse.phoneNumber,
                ),
                if (hasAddress)
                  _detailRow(
                    context,
                    icon: Icons.location_on_outlined,
                    label: S().address,
                    value: nurse.address ?? '-',
                    isLast: true,
                  ),
              ],
            ),
            SizedBox(height: 14.h),

            _sectionCard(
              context,
              title: S().personal_information,
              children: [
                _detailRow(
                  context,
                  icon: Icons.cake_outlined,
                  label: S().birth_date,
                  value:
                      '${Constant.formatDate(context, nurse.birthDate)} • ${nurse.age} ${S().years}',
                ),
                _detailRow(
                  context,
                  icon: Icons.wc_outlined,
                  label: S().gender,
                  value: nurse.gender,
                ),
                _detailRow(
                  context,
                  icon: Icons.favorite_outline,
                  label: S().marital_status,
                  value: nurse.maritalStatus ?? '-',
                ),
                _detailRow(
                  context,
                  icon: Icons.badge_outlined,
                  label: S().ssn,
                  value: nurse.ssn,
                  isLast: true,
                ),
              ],
            ),
            if (hasExperiences) ...[
              SizedBox(height: 14.h),
              _sectionCard(
                context,
                title: S().experiences,
                children: [
                  Text(
                    nurse.experiences ?? '-',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ],

            if (hasSocialHistory) ...[
              SizedBox(height: 14.h),
              _sectionCard(
                context,
                title: S().social_history,
                children: [
                  Text(
                    nurse.socialHistory ?? '-',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: StyleWidget.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha((0.08 * 255).toInt()),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 16, color: colorScheme.primary),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 150.w,
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
                ),
              ),
            ),
            SizedBox(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 5.h),
          Divider(
            height: 0.5,
            color: colorScheme.onSurface.withAlpha((0.06 * 255).toInt()),
          ),
          SizedBox(height: 10.h),
        ],
      ],
    );
  }
}
