import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/audit/views/audit_view.dart';
import 'package:marbella/features/shared/encounters/models/encounter_note_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EncounterNoteCard extends StatelessWidget {
  const EncounterNoteCard({
    super.key,
    required this.note,
    this.isEditable = false,
    this.onEdit,
    this.onDelete,
  });

  final EncounterNoteModel note;
  final bool isEditable;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _isActive {
    final untilRaw = note.untilDate;
    if (untilRaw == null || untilRaw.trim().isEmpty) return true;

    final until = DateTime.tryParse(untilRaw);
    if (until == null) return true;

    final today = DateTime.now();
    final untilDateOnly = DateTime(until.year, until.month, until.day);
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    return !todayDateOnly.isAfter(untilDateOnly);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasDuration = note.durationValue != null;
    final hasUntilDate =
        note.untilDate != null && note.untilDate!.trim().isNotEmpty;
    final statusColor = _isActive
        ? colorScheme.primary
        : colorScheme.onSurface.withAlpha((0.35 * 255).toInt());
    final role = context.read<AppRole>();

    bool isMobile = DeviceInfo.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 3.h : 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 30.w : 12.w,
          vertical: isMobile ? 10.h : 12.h,
        ),
        decoration: StyleWidget.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.08 * 255).toInt()),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.sticky_note_2_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    note.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isEditable)
                  SizedBox(
                    height: 25.h,
                    width: 20.w,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: colorScheme.onSurface.withAlpha(
                          (0.45 * 255).toInt(),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: colorScheme.surface,
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit?.call();
                        } else if (value == 'audit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AuditView(
                                id: note.id,
                                endPoint: EndPoints.encounterNote,
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          onDelete?.call();
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 19,
                                color: colorScheme.onSurface.withAlpha(
                                  (0.6 * 255).toInt(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                S().edit,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (role == AppRole.doctor) ...[
                          PopupMenuItem(
                            value: 'audit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.manage_history_rounded,
                                  size: 19,
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.6 * 255).toInt(),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Audit',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 19,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                S().delete,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),

            Text(
              note.note,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withAlpha((0.75 * 255).toInt()),
                height: 1.6,
              ),
            ),

            if (hasDuration || hasUntilDate) ...[
              SizedBox(height: 8.h),
              Divider(
                height: 0.5,
                color: colorScheme.onSurface.withAlpha((0.07 * 255).toInt()),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (hasDuration) ...[
                    Icon(
                      Icons.timelapse_outlined,
                      size: 15,
                      color: colorScheme.onSurface.withAlpha(
                        (0.4 * 255).toInt(),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${note.durationValue} ${note.durationUnit ?? ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.55 * 255).toInt(),
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (hasDuration && hasUntilDate) ...[
                    SizedBox(width: 14.w),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withAlpha(
                          (0.3 * 255).toInt(),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 14.w),
                  ],
                  if (hasUntilDate) ...[
                    Icon(
                      Icons.event,
                      size: 15,
                      color: colorScheme.onSurface.withAlpha(
                        (0.4 * 255).toInt(),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      Constant.formatDate(context, note.untilDate!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.55 * 255).toInt(),
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (hasUntilDate) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      _isActive ? S().active : S().ended,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
