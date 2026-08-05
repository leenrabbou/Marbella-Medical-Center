import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/features/only_doctor/appointments/widgets/appointments_tab_content.dart';
import 'package:marbella/generated/l10n.dart';

class AppointmentView extends StatelessWidget {
  const AppointmentView({
    super.key,
    required this.dateRangeFrom,
    required this.dateRangeTo,
    required this.patientId,
    required this.isFromPatient,
    this.search,
  });

  final String? dateRangeFrom;
  final String? dateRangeTo;
  final int? patientId;
  final String? search;
  final bool isFromPatient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tabs = [
      (status: 'all', label: S().all, noData: S().no_pending_appointments),
      (
        status: 'pending',
        label: S().pending,
        noData: S().no_pending_appointments,
      ),
      (status: 'booked', label: S().booked, noData: S().no_booked_appointments),
      (
        status: 'arrived',
        label: S().arrived,
        noData: S().no_arrived_appointments,
      ),
      (
        status: 'fulfilled',
        label: S().fulfilled,
        noData: S().no_fulfilled_appointments,
      ),
      (
        status: 'cancelled',
        label: S().cancelled,
        noData: S().no_cancelled_appointments,
      ),
      (
        status: 'no_show',
        label: S().no_show,
        noData: S().no_no_show_appointments,
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicator: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withAlpha(
              (0.6 * 255).toInt(),
            ),

            labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            tabs: tabs
                .map(
                  (t) => Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(t.label),
                    ),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: tabs
                  .map(
                    (t) => AppointmentsTabContent(
                      noDataMessage: t.noData,
                      status: t.status,
                      dateRangeFrom: dateRangeFrom,
                      dateRangeTo: dateRangeTo,
                      patientId: patientId,
                      search: search,
                      isFromPatient: isFromPatient,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
