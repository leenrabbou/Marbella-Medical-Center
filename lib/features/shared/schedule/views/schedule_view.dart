import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/schedule/viewmodels/schedule_viewmodel.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/schedule/widgets/schedule_card.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:marbella/features/shared/schedule/models/schedule_model.dart';
import 'package:provider/provider.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});
  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final Map<String, String> weekDays = {
    "sunday": S().sunday,
    "monday": S().monday,
    "tuesday": S().tuesday,
    "wednesday": S().wednesday,
    "thursday": S().thursday,
    "friday": S().friday,
    "saturday": S().saturday,
  };
  late String locale;
  String? token;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locale = Localizations.localeOf(context).languageCode;
      token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      context.read<ScheduleViewmodel>().getSchedule(locale, token);
    });
  }

  Future<void> _handleRefresh() async {
    final token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    final locale = Localizations.localeOf(context).languageCode;
    await context.read<ScheduleViewmodel>().getSchedule(locale, token);
  }

  Map<String, List<ScheduleModel>> groupSchedule(List<ScheduleModel> list) {
    final Map<String, List<ScheduleModel>> grouped = {};
    for (var item in list) {
      final dayKey = item.dayOfWeek.toLowerCase();
      if (!grouped.containsKey(dayKey)) {
        grouped[dayKey] = [];
      }
      grouped[dayKey]!.add(item);
    }
    for (var day in grouped.keys) {
      grouped[day]!.sort((a, b) {
        return (a.startTime ?? '').compareTo(b.startTime ?? '');
      });
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleViewmodel>();
    final grouped = groupSchedule(scheduleProvider.schedule);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(S().my_schedule)),
      body: LiquidPullToRefresh(
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        onRefresh: _handleRefresh,
        child: Center(
          child: StateWidget(
            isLoading: scheduleProvider.isLoading,
            error: scheduleProvider.errorMessage,
            isEmpty: scheduleProvider.schedule.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_schedule_subtitle,
            child: ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: weekDays.keys.map((dayKey) {
                final dayList = grouped[dayKey] ?? [];
                return ScheduleCard(
                  day: weekDays[dayKey]!,
                  schedules: dayList,
                  onDelete: (ScheduleModel p1) {},
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
