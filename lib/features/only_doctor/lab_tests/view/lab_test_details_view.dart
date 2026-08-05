import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/core/widgets/time_line_item.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_result_model.dart';
import 'package:marbella/features/only_doctor/lab_tests/viewmodel/lab_test_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class LabTestDetailsView extends StatefulWidget {
  const LabTestDetailsView({super.key, required this.labTestId});
  final int labTestId;

  @override
  State<LabTestDetailsView> createState() => _LabTestDetailsViewState();
}

class _LabTestDetailsViewState extends State<LabTestDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDetails());
  }

  Future<void> _fetchDetails() async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context).languageCode;
    final token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;

    await context.read<LabTestViewmodel>().getLabTestDetails(
      locale,
      token,
      widget.labTestId,
    );
  }

  Color _flagColor(String? flag) {
    switch (flag) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'low':
        return const Color(0xFF3B82F6);
      case 'normal':
      default:
        return const Color(0xFF22C55E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<LabTestViewmodel>();

    final labTest = provider.labTestDetailsFor(widget.labTestId);
    final isLoading = provider.isLoadingDetailsFor(widget.labTestId);
    final errorMessage = provider.errorMessageDetailsFor(widget.labTestId);

    final statusColor = labTest != null
        ? Constant.statusColor(labTest.status)
        : colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 15),
        ),
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: _fetchDetails,
          color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
          backgroundColor: colorScheme.surface,
          height: 50,
          child: StateWidget(
            isLoading: isLoading && labTest == null,
            error: errorMessage,
            isEmpty: false,
            onRetry: _fetchDetails,
            noDataMsg: S().no_data,
            child: labTest == null
                ? const SizedBox.shrink()
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          decoration: StyleWidget.cardDecoration(context),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withAlpha(
                                    (0.08 * 255).toInt(),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.biotech_outlined,
                                  color: colorScheme.primary,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                labTest.name,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${labTest.category} • ${labTest.codeSystem} ${labTest.code}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 7.h,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(
                                    (0.1 * 255).toInt(),
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  labTest.status.toUpperCase(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          ),
                          decoration: StyleWidget.cardDecoration(context),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timeline_outlined,
                                    size: 20,
                                    color: colorScheme.primary,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    S().timeline,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              TimeLineItem(
                                icon: Icons.assignment_outlined,
                                title: S().lab_ordered_at,
                                subtitle: Constant.formatDate(
                                  context,
                                  labTest.orderedAt,
                                ),
                                color: colorScheme.primary,
                              ),
                              SizedBox(height: 12.h),
                              TimeLineItem(
                                icon: Icons.colorize_outlined,
                                title: S().lab_sample_collected_at,
                                subtitle: labTest.sampleCollectedAt != null
                                    ? Constant.formatDate(
                                        context,
                                        labTest.sampleCollectedAt!,
                                      )
                                    : '-',
                                color: colorScheme.primary,
                              ),
                              SizedBox(height: 12.h),
                              TimeLineItem(
                                icon: Icons.check_circle_outline,
                                title: S().lab_completed_at,
                                subtitle: labTest.completedAt != null
                                    ? Constant.formatDate(
                                        context,
                                        labTest.completedAt!,
                                      )
                                    : '-',
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),

                        if (labTest.results != null &&
                            labTest.results!.isNotEmpty) ...[
                          Text(
                            S().lab_results,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ...labTest.results!.map(
                            (r) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _resultCard(context, r),
                            ),
                          ),
                        ],
                        if (labTest.notes != null &&
                            labTest.notes!.trim().isNotEmpty) ...[
                          Text(
                            S().notes,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 15.h,
                            ),
                            decoration: StyleWidget.cardDecoration(context),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sticky_note_2_outlined,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  labTest.notes!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(
                                      (0.75 * 255).toInt(),
                                    ),
                                    height: 1.5,
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
        ),
      ),
    );
  }

  Widget _resultCard(BuildContext context, LabResultModel result) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final flagColor = _flagColor(result.flag);
    final hasValue = result.value != null && result.value!.trim().isNotEmpty;
    final hasRange =
        result.referenceRangeMin != null && result.referenceRangeMax != null;
    final hasNotes = result.notes != null && result.notes!.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: flagColor.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: flagColor.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  result.flag != null ? result.flag! : '-',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: flagColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hasValue ? result.value! : '-',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: hasValue
                      ? flagColor
                      : colorScheme.onSurface.withAlpha((0.4 * 255).toInt()),
                ),
              ),
              if (result.unit != null) ...[
                SizedBox(width: 6.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    result.unit!,
                    style: theme.textTheme.bodyMedium?.copyWith(
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

          if (hasRange) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.straighten_outlined,
                  size: 14,
                  color: colorScheme.onSurface.withAlpha((0.4 * 255).toInt()),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${S().reference_range}: ${result.referenceRangeMin} - ${result.referenceRangeMax} ${result.unit ?? ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withAlpha(
                      (0.55 * 255).toInt(),
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (hasNotes) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha((0.05 * 255).toInt()),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      result.notes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.75 * 255).toInt(),
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
    );
  }
}
