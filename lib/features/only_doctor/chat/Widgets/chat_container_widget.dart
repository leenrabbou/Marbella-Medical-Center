import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatContainerWidget extends StatelessWidget {
  const ChatContainerWidget({
    super.key,
    required this.chat,
    this.onTap,
    this.isSelected = false,
  });

  final ConversationModel chat;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                imageUrl: chat.patient.image?.url,
                initials:
                    chat.patient.givenName.substring(0, 1) +
                    chat.patient.familyName.substring(0, 1),
                color:
                    Constant.listColors[(chat.patient.givenName +
                                chat.patient.familyName)
                            .length %
                        Constant.listColors.length],
              ),
              title: Text(
                chat.patient.givenName + chat.patient.familyName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                children: [
                  if (chat.lastMessage != null) ...[
                    if (chat.lastMessage!.isSender == 1) ...[
                      Constant.buildStatusIcon(
                        colorScheme: colorScheme,
                        message: chat.lastMessage!,
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (chat.lastMessage!.attachments.isNotEmpty) ...[
                            chat.lastMessage!.attachments.last.mimeType
                                    .startsWith('image/')
                                ? Icon(Icons.image_outlined, size: 15)
                                : Icon(Icons.picture_as_pdf_outlined, size: 15),
                            SizedBox(width: 4.w),
                          ],
                          Flexible(
                            child: Text(
                              chat.lastMessage!.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(
                                      (0.6 * 255).toInt(),
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              trailing: SizedBox(
                width: 60.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Constant.formatTime(chat.updatedAt),
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
