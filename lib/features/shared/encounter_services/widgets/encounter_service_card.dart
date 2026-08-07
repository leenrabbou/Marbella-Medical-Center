import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/audit/views/audit_view.dart';
import 'package:marbella/features/shared/encounter_services/models/encounter_service_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EncounterServiceCard extends StatelessWidget {
  const EncounterServiceCard({
    super.key,
    required this.encounterService,
    this.isEditable = false,
    this.onEdit,
    this.onDelete,
  });

  final EncounterServiceModel encounterService;
  final bool isEditable;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _isCompleted => encounterService.status == 'completed';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final service = encounterService.service;
    final bool hasNotes = encounterService.notes != null ? true : false;
    final statusColor = Constant.statusColor(encounterService.status);
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.08 * 255).toInt()),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (service.description.trim().isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            service.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withAlpha(
                                (0.45 * 255).toInt(),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (isEditable)
                  SizedBox(
                    height: isMobile ? 10.h : 25.h,
                    width: isMobile ? 60.w : 20.w,
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
                                id: encounterService.id,
                                endPoint: EndPoints.encounterService,
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
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5.h),
            Divider(
              height: 0.5,
              color: colorScheme.onSurface.withAlpha((0.07 * 255).toInt()),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  size: 18,
                  color: colorScheme.onSurface.withAlpha((0.4 * 255).toInt()),
                ),
                SizedBox(width: 8.w),
                Row(
                  children: [
                    Text(
                      Constant.formatPrice(encounterService.price),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      S().syp,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.7 * 255).toInt(),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),
                if (encounterService.performedAt != null) ...[
                  Icon(
                    Icons.event_available_outlined,
                    size: 15,
                    color: colorScheme.onSurface.withAlpha((0.4 * 255).toInt()),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    encounterService.performedAt != null
                        ? Constant.formatDate(
                            context,
                            encounterService.performedAt!,
                          )
                        : '-',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.55 * 255).toInt(),
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 14.w),
                ],

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isCompleted
                            ? Icons.check_circle_outline
                            : Icons.schedule_outlined,
                        size: 18,
                        color: statusColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        encounterService.status,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (hasNotes) ...[
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withAlpha((0.035 * 255).toInt()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sticky_note_2_outlined,
                      size: 18,
                      color: colorScheme.onSurface.withAlpha(
                        (0.4 * 255).toInt(),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        encounterService.notes ?? '-',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withAlpha(
                            (0.6 * 255).toInt(),
                          ),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
