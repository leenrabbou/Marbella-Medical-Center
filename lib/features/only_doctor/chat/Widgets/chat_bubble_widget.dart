import 'package:marbella/features/only_doctor/chat/Models/message_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({super.key, required this.messageInfo});
  final MessageInfoModel messageInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    String minute = messageInfo.time.minute.toString().padLeft(2, '0');
    String hour =
        (messageInfo.time.hour % 12 == 0 ? 12 : messageInfo.time.hour % 12)
            .toString();
    String period = messageInfo.time.hour >= 12 ? "PM" : "AM";
    String formattedTime = "$hour:$minute $period";

    return Align(
      alignment: messageInfo.isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: messageInfo.isMe ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: messageInfo.isMe
                ? const Radius.circular(20)
                : Radius.zero,
            bottomRight: messageInfo.isMe
                ? Radius.zero
                : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              messageInfo.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: messageInfo.isMe
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedTime,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: messageInfo.isMe
                        ? colorScheme.onPrimary.withAlpha((0.7 * 255).toInt())
                        : colorScheme.onSurfaceVariant.withAlpha(
                            (0.6 * 255).toInt(),
                          ),
                  ),
                ),
                if (messageInfo.isMe) ...[
                  const SizedBox(width: 6),
                  _buildStatusIcon(messageInfo.status, colorScheme),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status, ColorScheme colorScheme) {
    if (status == "seen") {
      return const Icon(Icons.done_all, size: 16, color: Colors.blue);
    } else if (status == "delevired") {
      return Icon(
        Icons.done_all,
        size: 16,
        color: colorScheme.onPrimary.withAlpha((0.5 * 255).toInt()),
      );
    } else {
      return Icon(
        Icons.check,
        size: 16,
        color: colorScheme.onPrimary.withAlpha((0.5 * 255).toInt()),
      );
    }
  }
}
