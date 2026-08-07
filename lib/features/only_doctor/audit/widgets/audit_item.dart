import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/audit/helper/audit_field_labels.dart';
import 'package:marbella/features/only_doctor/audit/helper/field_changes.dart';
import 'package:marbella/features/only_doctor/audit/models/audit_model.dart';
import 'package:marbella/generated/l10n.dart';

class AuditItem extends StatelessWidget {
  final AuditModel log;
  final bool isLast;

  const AuditItem({super.key, required this.log, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final eventStyle = _EventStyle.fromEvent(log.event, colorScheme);
    final changes = computeAuditDiff(log);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: eventStyle.color.withAlpha((0.12 * 255).toInt()),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: eventStyle.color.withAlpha((0.4 * 255).toInt()),
                    width: 1.5,
                  ),
                ),
                child: Icon(eventStyle.icon, size: 18, color: eventStyle.color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: colorScheme.onSurface.withAlpha(
                      (0.08 * 255).toInt(),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                decoration: StyleWidget.cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.user.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                log.user.role,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _EventBadge(style: eventStyle),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    Divider(
                      height: 0.5,
                      color: colorScheme.onSurface.withAlpha(
                        (0.08 * 255).toInt(),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    if (changes.isEmpty)
                      Text(
                        S().no_changes_detected,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withAlpha(
                            (0.5 * 255).toInt(),
                          ),
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: changes
                            .map((c) => _FieldChangeRow(change: c))
                            .toList(),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: colorScheme.onSurface.withAlpha(
                            (0.4 * 255).toInt(),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${Constant.formatDate(context, log.updatedAt)} • ${Constant.formatTime(log.updatedAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withAlpha(
                              (0.4 * 255).toInt(),
                            ),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldChangeRow extends StatelessWidget {
  final FieldChange change;

  const _FieldChangeRow({required this.change});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasOldValue = change.oldValue != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 5.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha((0.6 * 255).toInt()),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuditFieldLabels.labelFor(change.key),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withAlpha(
                      (0.65 * 255).toInt(),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (hasOldValue) ...[
                      Text(
                        _displayValue(change.oldValue),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                          color: colorScheme.onSurface.withAlpha(
                            (0.6 * 255).toInt(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.arrow_forward_sharp,
                          size: 14,
                          color: colorScheme.onSurface.withAlpha(
                            (0.35 * 255).toInt(),
                          ),
                        ),
                      ),
                    ],
                    Text(
                      _displayValue(change.newValue),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _displayValue(dynamic value) {
    if (value == null) return S().not_set;
    if (value is String && value.isEmpty) return S().not_set;
    return value.toString();
  }
}

class _EventBadge extends StatelessWidget {
  final _EventStyle style;

  const _EventBadge({required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        style.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: style.color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _EventStyle {
  final Color color;
  final IconData icon;
  final String label;

  _EventStyle({required this.color, required this.icon, required this.label});

  factory _EventStyle.fromEvent(String event, ColorScheme colorScheme) {
    switch (event) {
      case 'created':
        return _EventStyle(
          color: Colors.green.shade600,
          icon: Icons.add_circle_outline_rounded,
          label: S().event_created,
        );
      case 'deleted':
        return _EventStyle(
          color: Colors.red.shade600,
          icon: Icons.delete_outline_rounded,
          label: S().event_deleted,
        );
      case 'updated':
      default:
        return _EventStyle(
          color: Colors.orange.shade700,
          icon: Icons.edit_outlined,
          label: S().event_updated,
        );
    }
  }
}
