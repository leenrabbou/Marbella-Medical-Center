import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_test_model.dart';
import 'package:marbella/features/only_doctor/lab_tests/view/lab_test_details_view.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabTestCard extends StatelessWidget {
  const LabTestCard({
    super.key,
    required this.labTest,
    required this.onDelete,
    required this.isRequest,
  });

  final LabTestModel labTest;
  final VoidCallback? onDelete;
  final bool isRequest;

  IconData get _statusIcon {
    switch (labTest.status) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'ordered':
      default:
        return Icons.schedule_outlined;
    }
  }

  bool get isEditable => labTest.status == 'ordered';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = Constant.statusColor(labTest.status);
    final hasNotes = labTest.notes != null && labTest.notes!.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LabTestDetailsView(labTestId: labTest.id),
          ),
        ),
        child: Container(
          decoration: StyleWidget.cardDecoration(context),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isRequest) ...[
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withAlpha(
                                  (0.08 * 255).toInt(),
                                ),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(
                                Icons.biotech_outlined,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      labTest.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      '${labTest.category} • ${labTest.code}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withAlpha(
                                                  (0.45 * 255).toInt(),
                                                ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const Spacer(),
                            ...[
                              Icon(
                                Icons.event_outlined,
                                size: 14,
                                color: colorScheme.onSurface.withAlpha(
                                  (0.4 * 255).toInt(),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                Constant.formatDate(context, labTest.orderedAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.55 * 255).toInt(),
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 12.w),
                            ],
                            if (isRequest) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(
                                    (0.1 * 255).toInt(),
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _statusIcon,
                                      size: 13,
                                      color: statusColor,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      labTest.status,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            if (isEditable)
                              SizedBox(
                                height: 25.h,
                                width: 25.w,
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
                                    if (value == 'cancel') onDelete?.call();
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      value: 'cancel',
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete_outline,
                                            color: Colors.redAccent,
                                            size: 19,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            S().cancel,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
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

                        if (hasNotes) ...[
                          SizedBox(height: 10.h),
                          Divider(
                            height: 0.5,
                            color: colorScheme.onSurface.withAlpha(
                              (0.07 * 255).toInt(),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface.withAlpha(
                                (0.035 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.sticky_note_2_outlined,
                                  size: 14,
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.4 * 255).toInt(),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    labTest.notes!,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
