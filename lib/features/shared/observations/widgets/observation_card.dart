import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/only_doctor/audit/views/audit_view.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/observations/models/observation_model.dart';
import 'package:marbella/features/shared/observations/viewmodels/observation_viewmodel.dart';
import 'package:marbella/features/shared/observations/widgets/observation_dialogs.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ObservationCard extends StatefulWidget {
  const ObservationCard({
    super.key,
    required this.observation,
    required this.isEditable,
    required this.onSuccess,
  });
  final ObservationModel observation;
  final bool isEditable;
  final Future<void> Function()? onSuccess;

  @override
  State<ObservationCard> createState() => _ObservationCardState();
}

class _ObservationCardState extends State<ObservationCard> {
  @override
  Widget build(BuildContext context) {
    final color = Constant.observationColor(widget.observation.code.code);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    bool isMobile = DeviceInfo.isMobile(context);
    final hasNote =
        widget.observation.note != null &&
        widget.observation.note!.trim().isNotEmpty;
    final role = context.read<AppRole>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 3.h : 4.h),
      child: Container(
        decoration: StyleWidget.cardDecoration(context),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 30.w : 12.w,
          vertical: isMobile ? 10.h : 12.h,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: color.withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Constant.observationIcon(
                              widget.observation.code.code,
                            ),
                            color: color,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.observation.code.display,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                Constant.formatDate(
                                  context,
                                  widget.observation.effectiveDatetime,
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.isEditable)
                          SizedBox(
                            height: isMobile ? 10.h : 25.h,
                            width: isMobile ? 50.w : 20.w,
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.more_vert,
                                size: 18,
                                color: colorScheme.onSurface.withAlpha(
                                  (0.4 * 255).toInt(),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              color: colorScheme.surface,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  ObservationDialogs()
                                      .showEditObservationDialog(
                                        context,
                                        widget.observation,
                                        0,
                                        widget.onSuccess,
                                      );
                                } else if (value == 'audit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AuditView(
                                        id: widget.observation.id,
                                        endPoint: EndPoints.observation,
                                      ),
                                    ),
                                  );
                                } else if (value == 'delete') {
                                  _showDeleteDialog(context, widget.onSuccess);
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
                                      SizedBox(width: 10.w),
                                      Text(
                                        S().edit,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
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
                                          color: colorScheme.onSurface
                                              .withAlpha((0.6 * 255).toInt()),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          'Audit',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
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
                                      SizedBox(width: 10.w),
                                      Text(
                                        S().delete,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 5.h),
                    Divider(
                      height: 0.1,
                      color: colorScheme.onSurface.withAlpha(
                        (0.05 * 255).toInt(),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.observation.value ?? '-',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (widget.observation.unit != null) ...[
                          SizedBox(width: 6.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              widget.observation.unit!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withAlpha(
                                  (0.5 * 255).toInt(),
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (hasNote) ...[
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withAlpha(
                            (0.035 * 255).toInt(),
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.sticky_note_2_outlined,
                              color: colorScheme.primary,
                              size: 17,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                widget.observation.note!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.7 * 255).toInt(),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Future<void> Function()? onSuccess,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final observationProvider = context.watch<ObservationViewmodel>();
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                S().delete_observation,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().observation_delete_warning,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    S().are_you_sure_continue,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      height: 40,
                      width: 120,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 15,
                      color: colorScheme.surface,
                      textColor: colorScheme.primary,
                      elevation: 0,
                      child: Text(S().cancel, style: theme.textTheme.bodySmall),
                    ),
                    CustomButtonWidget(
                      onPressed: observationProvider.deleteisLoading
                          ? null
                          : () async {
                              final locale = Localizations.localeOf(
                                context,
                              ).languageCode;
                              final token =
                                  context
                                      .read<AuthViewmodel>()
                                      .response
                                      ?.data
                                      ?.token ??
                                  context
                                      .read<AuthViewmodel>()
                                      .userFromCache
                                      ?.data
                                      ?.token;
                              bool success = await observationProvider
                                  .deleteObservation(
                                    widget.observation.id,
                                    locale,
                                    token,
                                  );

                              if (success) {
                                AppSnackbar.show(
                                  context,
                                  message: S().observation_deleted,
                                  type: SnackbarType.success,
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                                onSuccess?.call();
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      observationProvider.deleteErrorMessage ??
                                      S().error,
                                  type: SnackbarType.error,
                                );
                              }
                            },
                      height: 40,
                      width: 120,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 18,
                      color: Colors.redAccent,
                      elevation: 3,
                      textColor: Colors.white,
                      child: observationProvider.deleteisLoading
                          ? const SpinKitThreeInOut(
                              color: Colors.white,
                              size: 20,
                            )
                          : Text(
                              S().delete,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
