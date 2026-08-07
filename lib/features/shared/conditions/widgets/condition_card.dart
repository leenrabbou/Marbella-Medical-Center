import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/only_doctor/audit/views/audit_view.dart';
import 'package:marbella/features/shared/conditions/models/condition_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ConditionCard extends StatefulWidget {
  const ConditionCard({
    super.key,
    required this.condition,
    required this.isEditable,
    this.onEdit,
    this.onDelete,
  });

  final ConditionModel condition;
  final bool isEditable;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<ConditionCard> createState() => _ConditionCardState();
}

class _ConditionCardState extends State<ConditionCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final clinicalColor = Constant.statusColor(widget.condition.clinicalStatus);
    final verificationColor = Constant.statusColor(
      widget.condition.verificationStatus,
    );

    final isResolved =
        widget.condition.abatementDate != null &&
        widget.condition.abatementDate!.trim().isNotEmpty;
    bool isMobile = DeviceInfo.isMobile(context);
    final role = context.read<AppRole>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 3.h : 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 30.w : 12.w,
          vertical: isMobile ? 10.h : 12.h,
        ),
        decoration: StyleWidget.cardDecoration(context),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.medical_information_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: isMobile ? 14.w : 10.w),
                Expanded(
                  child: Text(
                    widget.condition.code.display,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Column(
                  children: [
                    Container(
                      width: isMobile ? 250.w : 100.w,
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: clinicalColor.withAlpha((0.07 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          widget.condition.clinicalStatus,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: clinicalColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Container(
                          width: isMobile ? 250.w : 100.w,
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: verificationColor.withAlpha(
                                (0.4 * 255).toInt(),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.condition.verificationStatus,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: verificationColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (widget.isEditable) ...[
                  SizedBox(
                    height: 40.h,
                    width: 25.w,
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: colorScheme.onSurface.withAlpha(
                          (0.5 * 255).toInt(),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: colorScheme.surface,
                      onSelected: (value) {
                        if (value == 'edit') {
                          widget.onEdit?.call();
                        } else if (value == 'audit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AuditView(
                                id: widget.condition.id,
                                endPoint: EndPoints.condition,
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          widget.onDelete?.call();
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: colorScheme.onSurface.withAlpha(
                                  (0.5 * 255).toInt(),
                                ),
                              ),
                              SizedBox(width: 10.w),
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
                                color: Colors.red,
                                size: 20,
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
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _TimelineTile(
                    label: S().onset_label,
                    value: Constant.formatDate(
                      context,
                      widget.condition.onsetDate,
                    ),
                  ),
                ),
                if (isResolved) ...[
                  Expanded(
                    child: _TimelineTile(
                      label: S().resolved_label,
                      value: Constant.formatDate(
                        context,
                        widget.condition.abatementDate!,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            if (widget.condition.note != null &&
                widget.condition.note!.trim().isNotEmpty) ...[
              SizedBox(height: isMobile ? 8.h : 10.h),
              Divider(
                height: 0.5,
                color: colorScheme.onSurface.withAlpha((0.08 * 255).toInt()),
              ),
              SizedBox(height: isMobile ? 8.h : 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    color: colorScheme.primary,
                    size: isMobile ? 16 : 20,
                  ),
                  SizedBox(width: isMobile ? 14.w : 10.w),
                  Expanded(
                    child: Text(
                      widget.condition.note!,
                      style: theme.textTheme.bodyMedium,
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
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
