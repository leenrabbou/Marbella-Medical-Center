import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/models/drug_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/widgets/empty_section.dart';
import 'package:marbella/generated/l10n.dart';

class DrugInteractionsTab extends StatelessWidget {
  const DrugInteractionsTab({super.key, required this.drugInteractions});
  final List<DrugInteractionModel> drugInteractions;
  @override
  Widget build(BuildContext context) {
    if (drugInteractions.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          EmptySection(
            icon: Icons.check_circle_outline_rounded,
            message: S().noDrugInteractions,
          ),
        ],
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      itemCount: drugInteractions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _drugInteractionCard(context, drugInteractions[index]),
        );
      },
    );
  }

  Widget _drugInteractionCard(
    BuildContext context,
    DrugInteractionModel interaction,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final other = interaction.drugInteraction;
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
                          other.code.display,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),

                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SeverityBadge(severity: interaction.severity),
                    ],
                  ),
                  if (((other.form).isNotEmpty) ||
                      ((other.strength ?? '').isNotEmpty)) ...[
                    SizedBox(height: 6.h),
                    Text(
                      [
                        other.form,
                        other.strength,
                      ].where((e) => (e ?? '').isNotEmpty).join(' • '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withAlpha((0.55 * 255).toInt()),
                      ),
                    ),
                  ],
                  if ((interaction.description ?? '').isNotEmpty) ...[
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
                            interaction.description!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: scheme.onSurface.withAlpha(
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
