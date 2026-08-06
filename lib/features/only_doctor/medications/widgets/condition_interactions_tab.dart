import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/models/condition_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/widgets/empty_section.dart';
import 'package:marbella/features/only_doctor/medications/widgets/interactions_dialogs.dart';
import 'package:marbella/generated/l10n.dart';

class ConditionInteractionsTab extends StatelessWidget {
  const ConditionInteractionsTab({
    super.key,
    required this.conditionInteractions,
  });
  final List<ConditionInteractionModel> conditionInteractions;

  @override
  Widget build(BuildContext context) {
    if (conditionInteractions.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          EmptySection(
            icon: Icons.check_circle_outline_rounded,
            message: S().noConditionInteractions,
          ),
        ],
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: conditionInteractions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _conditionInteractionCard(
            context,
            conditionInteractions[index],
          ),
        );
      },
    );
  }

  Widget _conditionInteractionCard(
    BuildContext context,
    ConditionInteractionModel interaction,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final code = interaction.conditionInteraction;

    final statusColor = Constant.statusColor(interaction.severity);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4.w,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              decoration: StyleWidget.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          code.display,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SeverityBadge(severity: interaction.severity),

                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
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
                            if (value == 'delete') {
                              InteractionsDialogs.showDeleteDialog(
                                context,
                                interaction.id,
                              );
                            }
                          },
                          itemBuilder: (_) => [
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
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${code.code} • ${code.category}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.55 * 255).toInt(),
                      ),
                    ),
                  ),
                  if (interaction.description != null) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 6.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(10),
                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.notes, size: 18),
                          SizedBox(width: 7.w),
                          Text(
                            interaction.description ?? '-',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.7 * 255).toInt(),
                                  ),
                                  height: 1.4,
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
    );
  }
}
