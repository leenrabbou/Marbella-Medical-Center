import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/core/widgets/time_line_item.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class OverViewEncounterTab extends StatefulWidget {
  const OverViewEncounterTab({
    super.key,
    required this.isEditable,
    required this.reasonController,
    required this.notesController,
    required this.encounter,
  });
  final bool isEditable;
  final TextEditingController? reasonController;
  final TextEditingController? notesController;
  final EncounterModel encounter;

  @override
  State<OverViewEncounterTab> createState() => _OverViewEncounterTabState();
}

class _OverViewEncounterTabState extends State<OverViewEncounterTab> {
  late String locale;
  String? token;
  late EncounterModel _encounter;

  @override
  void initState() {
    super.initState();
    _encounter = widget.encounter;
  }

  Future<void> _handleRefresh() async {
    if (!mounted) return;

    final locale = Localizations.localeOf(context).languageCode;

    final token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;

    if (token == null) return;
    final provider = context.read<EncounterViewmodel>();

    await provider.getEncounterDetails(locale, token, _encounter.id);

    if (mounted && provider.encounterDetailsFor(_encounter.id) != null) {
      setState(() {
        _encounter = provider.encounterDetailsFor(_encounter.id)!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<EncounterViewmodel>();

    final id = _encounter.id;
    final bool isLoading = provider.isLoadingDetailsFor(id);
    final String? errorMessage = provider.errorMessageDetailsFor(id);
    final bool isMobile = DeviceInfo.isMobile(context);

    return LiquidPullToRefresh(
      color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
      backgroundColor: colorScheme.surface,
      height: 50,
      onRefresh: _handleRefresh,
      child: StateWidget(
        isLoading: isLoading && provider.encounterDetailsFor(id) == null,
        error: errorMessage,
        isEmpty: false,
        onRetry: _handleRefresh,
        noDataMsg: S().no_data,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: isMobile ? 0 : 5.h,
          ),
          child: isMobile
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      _buildSideSection(context, _encounter),
                      SizedBox(height: isMobile ? 7.h : 12.h),
                      _buildMainContent(context, _encounter),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildMainContent(context, _encounter),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      flex: 1,
                      child: _buildSideSection(context, _encounter),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, EncounterModel encounter) {
    bool isMobile = DeviceInfo.isMobile(context);
    return Column(
      children: [
        _reasonCard(context, encounter),
        SizedBox(height: isMobile ? 7.h : 10.h),
        _clinicalNotesCard(context, encounter),
      ],
    );
  }

  Widget _buildSideSection(BuildContext context, EncounterModel encounter) {
    bool isMobile = DeviceInfo.isMobile(context);
    return Column(
      children: [
        _statusCard(context, encounter),
        SizedBox(height: isMobile ? 7.h : 10.h),
        _timelineCard(context, encounter),
      ],
    );
  }

  Widget _reasonCard(BuildContext context, EncounterModel encounter) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool isMobile = DeviceInfo.isMobile(context);
    return Container(
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
              Icon(Icons.sick_outlined, size: isMobile ? 20 : 22),
              SizedBox(width: isMobile ? 14.w : 10.w),
              Text(
                S().chief_complaint,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 5.h : 10.h),
          TextField(
            controller: widget.reasonController,
            enabled: widget.isEditable,
            style: widget.isEditable
                ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  )
                : null,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: encounter.reason ?? S().enter_reason_hint,
              filled: true,
              fillColor: colorScheme.onSurface.withAlpha((0.03 * 255).toInt()),
              border: StyleWidget.border(context),
              disabledBorder: StyleWidget.border(context),
              enabledBorder: StyleWidget.border(context),
              focusedBorder: StyleWidget.focusedBorder(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clinicalNotesCard(BuildContext context, EncounterModel encounter) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool isMobile = DeviceInfo.isMobile(context);
    return Container(
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
              Icon(Icons.description_outlined, size: isMobile ? 20 : 22),
              SizedBox(width: isMobile ? 14.w : 10.w),
              Text(
                S().clinical_notes,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 5.h : 10.h),
          TextField(
            controller: widget.notesController,
            enabled: widget.isEditable,
            maxLines: 5,
            style: widget.isEditable
                ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  )
                : null,
            decoration: InputDecoration(
              hintText: encounter.notes ?? S().add_clinical_notes_hint,
              filled: true,
              fillColor: colorScheme.onSurface.withAlpha((0.03 * 255).toInt()),
              border: StyleWidget.border(context),
              disabledBorder: StyleWidget.border(context),
              enabledBorder: StyleWidget.border(context),
              focusedBorder: StyleWidget.focusedBorder(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(BuildContext context, EncounterModel encounter) {
    final statusColor = Constant.statusColor(encounter.status);
    bool isMobile = DeviceInfo.isMobile(context);

    return Container(
      width: double.infinity,
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
              Icon(Icons.flag_outlined, size: isMobile ? 20 : 22),
              SizedBox(width: isMobile ? 14.w : 10.w),
              Text(
                S().visit_status,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 5.h : 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: statusColor.withAlpha((0.15 * 255).toInt()),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              encounter.status.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineCard(BuildContext context, EncounterModel encounter) {
    bool isMobile = DeviceInfo.isMobile(context);
    return Container(
      width: double.infinity,
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
              Icon(Icons.timeline_outlined, size: isMobile ? 20 : 22),
              SizedBox(width: isMobile ? 14.w : 10.w),
              Text(
                S().timeline,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 5.h : 10.h),
          TimeLineItem(
            icon: Icons.play_circle_outline,
            title: S().visit_started,
            subtitle: encounter.startTime != null
                ? '${Constant.formatDate(context, encounter.startTime!)} • ${Constant.formatTime(encounter.startTime)}'
                : '-',
            color: Colors.green,
          ),
          SizedBox(height: 12.h),
          TimeLineItem(
            icon: Icons.check_circle_outline,
            title: S().visit_finished,
            subtitle: encounter.endTime != null
                ? '${Constant.formatDate(context, encounter.endTime!)} • ${Constant.formatTime(encounter.endTime)}'
                : '-',
            color: Colors.red,
          ),
          SizedBox(height: 12.h),
          TimeLineItem(
            icon: Icons.timer_outlined,
            title: S().duration,
            subtitle: encounter.startTime != null && encounter.endTime != null
                ? Constant.calDuration(encounter.startTime!, encounter.endTime!)
                : '-',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
