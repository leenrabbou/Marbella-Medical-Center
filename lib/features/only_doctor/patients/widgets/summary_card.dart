import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.encounterCount,
    required this.conditionsCount,
    required this.medicationCount,
  });
  final int encounterCount;
  final int medicationCount;
  final int conditionsCount;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: StyleWidget.cardDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S().summary,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.w),
          Divider(
            height: 3,
            color: colorScheme.onSurface.withAlpha((0.05 * 255).toInt()),
          ),
          _buildChip(
            context,
            S().total_encounters,
            Icons.folder_open_outlined,
            '$encounterCount',
          ),
          Divider(
            height: 3,
            color: colorScheme.onSurface.withAlpha((0.05 * 255).toInt()),
          ),
          _buildChip(
            context,
            S().medications_tab,
            Icons.medication_outlined,
            '$medicationCount',
          ),
          Divider(
            height: 3,
            color: colorScheme.onSurface.withAlpha((0.05 * 255).toInt()),
          ),
          _buildChip(
            context,
            S().conditions,
            Icons.warning_amber_rounded,
            '$conditionsCount',
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String text,
    IconData icon,
    String number,
  ) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: colorScheme.primary),
              ),
              SizedBox(width: 10.w),
              Text(text, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          Text(number, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
