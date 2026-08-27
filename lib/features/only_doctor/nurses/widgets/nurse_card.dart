import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/nurses/views/nurse_details_view.dart';
import 'package:marbella/features/only_doctor/nurses/widgets/nurse_dialogs.dart';
import 'package:marbella/features/shared/profile/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/generated/l10n.dart';

class NurseCard extends StatelessWidget {
  const NurseCard({
    super.key,
    required this.nurse,
    required this.encounterId,
    this.isEditable = false,
    required this.onSuccess,
  });

  final EmployeeModel nurse;
  final int encounterId;
  final bool isEditable;
  final Future<void> Function()? onSuccess;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasSpecialization = nurse.specialization.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NurseDetailsView(
              nurse: nurse,
              encounterId: encounterId,
              isEditable: isEditable,
              onSuccess: onSuccess,
            ),
          ),
        ),
        child: Container(
          decoration: StyleWidget.cardDecoration(context),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(
                size: 50.w,
                imageUrl: nurse.image?.url,
                initials:
                    '${nurse.firstName.isNotEmpty ? nurse.firstName[0] : ''}${nurse.lastName.isNotEmpty ? nurse.lastName[0] : ''}'
                        .toUpperCase(),
              ),
              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${nurse.firstName} ${nurse.lastName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    if (hasSpecialization)
                      Text(
                        nurse.specialization,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary.withAlpha(
                            (0.8 * 255).toInt(),
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android_outlined,
                          size: 13,
                          color: colorScheme.onSurface.withAlpha(
                            (0.4 * 255).toInt(),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          nurse.phoneNumber,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withAlpha(
                              (0.5 * 255).toInt(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isEditable) ...[
                SizedBox(width: 6.w),
                SizedBox(
                  height: 28.h,
                  width: 28.w,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.more_vert,
                      size: 19,
                      color: colorScheme.onSurface.withAlpha(
                        (0.4 * 255).toInt(),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: colorScheme.surface,
                    onSelected: (value) {
                      if (value == 'delete') {
                        NurseDialogs.showDeleteDialog(
                          context,
                          encounterId,
                          nurse.id,
                          onSuccess: onSuccess,
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_remove_outlined,
                              color: Colors.redAccent,
                              size: 19,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              S().remove,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
