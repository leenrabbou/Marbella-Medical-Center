import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:marbella/features/only_doctor/appointments/views/appointment_view.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/generated/l10n.dart';

class AllAppointmentsView extends StatefulWidget {
  const AllAppointmentsView({super.key});

  @override
  State<AllAppointmentsView> createState() => _AllAppointmentsViewState();
}

class _AllAppointmentsViewState extends State<AllAppointmentsView> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> weekDays = [];
  String? dateRangeFrom;
  String? dateRangeTo;

  @override
  void initState() {
    super.initState();
    _generateWeekDays(selectedDate);
    _updateDateRange();
  }

  void _updateDateRange() {
    final dateToString =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    dateRangeFrom = dateToString;
    dateRangeTo = dateToString;
  }

  void _generateWeekDays(DateTime center) {
    final start = center.subtract(Duration(days: center.weekday % 7));
    weekDays = List.generate(7, (i) => start.add(Duration(days: i)));
  }

  void _onDateSelected(DateTime d) {
    setState(() {
      selectedDate = d;
      _generateWeekDays(d);
      _updateDateRange();
    });
  }

  Future<void> _showGoToDateModal() async {
    int selectedMonth = selectedDate.month - 1;
    int selectedDay = selectedDate.day - 1;
    int selectedYear = selectedDate.year;
    final bool isArabic = LocalizationViewmodel.isArabic();
    final years = List<int>.generate(30, (i) => DateTime.now().year - 10 + i);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  S().go_to_date,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 30,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedDay,
                          ),
                          onSelectedItemChanged: (i) => selectedDay = i,
                          children: List.generate(
                            31,
                            (i) => Center(
                              child: Text(
                                '${i + 1}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 30,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedMonth,
                          ),
                          onSelectedItemChanged: (i) => selectedMonth = i,
                          children: List.generate(
                            12,
                            (i) => Center(
                              child: Text(
                                DateFormat.MMM().format(DateTime(0, i + 1)),
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 30,
                          scrollController: FixedExtentScrollController(
                            initialItem: years.indexOf(selectedYear),
                          ),
                          onSelectedItemChanged: (i) => selectedYear = years[i],
                          children: years
                              .map(
                                (y) => Center(
                                  child: Text(
                                    '$y',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      height: 40,
                      width: 140,
                      left: isArabic ? 30 : 0,
                      right: isArabic ? 0 : 30,
                      top: 5,
                      bottom: 10,
                      textSize: 15,
                      color: theme.colorScheme.surface,
                      textColor: colorScheme.primary,
                      elevation: 0,
                      child: Text(
                        S().cancel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomButtonWidget(
                      onPressed: () {
                        final chosen = DateTime(
                          selectedYear,
                          selectedMonth + 1,
                          selectedDay + 1,
                        );
                        _onDateSelected(chosen);
                        Navigator.of(context).pop();
                      },
                      height: 40,
                      width: 140,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 10,
                      textSize: 15,
                      color: colorScheme.primary,
                      elevation: 5,
                      textColor: Colors.white,
                      child: Text(
                        S().confirm,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopCalendar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((d) {
              final isSelected =
                  DateFormat('yyyy-MM-dd').format(d) ==
                  DateFormat('yyyy-MM-dd').format(selectedDate);
              return GestureDetector(
                onTap: () => _onDateSelected(d),
                child: Column(
                  children: [
                    Text(
                      DateFormat.E().format(d),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Container(
                      height: 26.h,
                      width: 26.w,
                      decoration: isSelected
                          ? BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            )
                          : const BoxDecoration(),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          '${d.day}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: _showGoToDateModal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEEE • MMM d').format(selectedDate),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: colorScheme.onSurface.withAlpha((0.4 * 255).toInt()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S().appointments)),
      body: Column(
        children: [
          _buildTopCalendar(),
          Expanded(
            child: AppointmentView(
              dateRangeFrom: dateRangeFrom,
              dateRangeTo: dateRangeTo,
              patientId: null,
              isFromPatient: false,
            ),
          ),
        ],
      ),
    );
  }
}
