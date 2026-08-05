import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/features/only_doctor/chat/Models/chat_model.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatContainerWidget extends StatelessWidget {
  const ChatContainerWidget({
    super.key,
    required this.chat,
    this.onTap,
    this.isSelected = false,
  });

  final ChatModel chat;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    String formattedTime = "";
    int hour = chat.time.hour > 12
        ? chat.time.hour - 12
        : (chat.time.hour == 0 ? 12 : chat.time.hour);
    String period = chat.time.hour >= 12 ? "PM" : "AM";
    String minute = chat.time.minute.toString().padLeft(2, '0');
    PatientModel patient = PatientModel(
      id: 1,
      image: null,
      phoneNumber: 'phoneNumber',
      givenName: 'givenName',
      familyName: 'familyName',
      gender: 'gender',
      phoneNumberVerifiedAt: 'phoneNumberVerifiedAt',
      maritalStatus: 'maritalStatus',
      dateOfBirth: 'dateOfBirth',
      socialHistory: 'socialHistory',
      occupation: 'occupation',
      active: true,
      nationalId: 'nationalId',
      notes: 'notes',
      bloodGroup: 'bloodGroup',
    );
    formattedTime = "$hour:$minute $period";
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withAlpha((0.07 * 255).toInt())
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: isSelected
                  ? Border.all(
                      color: colorScheme.primary.withAlpha(
                        (0.05 * 255).toInt(),
                      ),
                      width: 1.2,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                  color: Colors.black.withAlpha((0.04 * 255).toInt()),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 3.h,
              ),
              leading: AppAvatar(
                size: 50.r,
                imageUrl: patient.image?.url,
                initials:
                    patient.givenName.substring(0, 1) +
                    patient.familyName.substring(0, 1),
                color:
                    Constant.listColors[(patient.givenName + patient.familyName)
                            .length %
                        Constant.listColors.length],
              ),
              title: Text(
                chat.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                children: [
                  chat.status == "seen"
                      ? Icon(Icons.done_all, size: 18, color: Colors.blue)
                      : chat.status == "delevired"
                      ? Icon(Icons.done_all, size: 18, color: Colors.grey)
                      : const Icon(Icons.check, size: 18, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      chat.lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.6 * 255).toInt(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 60.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedTime,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.4 * 255).toInt(),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (chat.unreadCount > 0)
                      UnconstrainedBox(
                        alignment: Alignment.centerRight,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 22.r,
                            minHeight: 22.r,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.r,
                            vertical: 4.r,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            chat.unreadCount > 99
                                ? "99+"
                                : chat.unreadCount.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                          ),
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
}
