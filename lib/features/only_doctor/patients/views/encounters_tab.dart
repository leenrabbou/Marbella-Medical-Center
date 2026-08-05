import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:marbella/features/shared/encounters/views/encounter_details_view.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_viewmodel.dart';
import 'package:provider/provider.dart';

class EncountersTab extends StatefulWidget {
  const EncountersTab({
    super.key,
    required this.status,
    required this.patientId,
  });
  final String? status;
  final int patientId;
  @override
  State<EncountersTab> createState() => _EncountersTabState();
}

class _EncountersTabState extends State<EncountersTab> {
  final ScrollController _scrollController = ScrollController();
  String? _locale;
  String? _token;
  EncounterParams? _params;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locale = Localizations.localeOf(context).languageCode;
      _token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      _params = EncounterParams(
        search: null,
        status: null,
        patientId: widget.patientId,
      );
      final provider = context.read<EncounterViewmodel>();
      if (provider.allEncounters.isEmpty && !provider.isLoading) {
        provider.refreshToFetchDataList(_locale!, _token, _params!);
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_locale == null || _params == null) return;
    final provider = context.read<EncounterViewmodel>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.getIsFetching(widget.status) &&
        provider.getHasMore(widget.status)) {
      provider.getEncounters(
        _locale!,
        _token,
        _params!,
        provider.getCurrentPage(widget.status),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final encounterProvider = context.watch<EncounterViewmodel>();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StateWidget(
      isLoading: encounterProvider.isLoading,
      error: encounterProvider.errorMessage,
      isEmpty:
          !encounterProvider.isLoading &&
          encounterProvider.allEncounters.isEmpty &&
          encounterProvider.errorMessage == null,
      onRetry: () => encounterProvider.refreshToFetchDataList(
        _locale ?? '',
        _token,
        _params!,
      ),
      noDataMsg: S().no_encounters_found,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        itemCount: encounterProvider.allEncounters.length,
        itemBuilder: (context, index) {
          final encounter = encounterProvider.allEncounters[index];
          final bool isLastItem =
              index == encounterProvider.allEncounters.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 60.w,
                  child: encounter.startTime == null
                      ? Text(
                          S().no_date,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withAlpha(
                                  (0.6 * 255).toInt(),
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              encounter.startTime == null
                                  ? ''
                                  : Constant.getDay(encounter.startTime!),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              encounter.startTime == null
                                  ? ''
                                  : Constant.getMonthName(encounter.startTime!),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(
                                      (0.6 * 255).toInt(),
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              encounter.startTime == null
                                  ? ''
                                  : Constant.getYear(encounter.startTime!),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(
                                      (0.25 * 255).toInt(),
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  width: 12.w,
                  child: Column(
                    children: [
                      Container(
                        width: 14.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withAlpha(
                                (0.3 * 255).toInt(),
                              ),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      if (!isLastItem)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: colorScheme.primary.withAlpha(
                              (0.2 * 255).toInt(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EncounterDetailsView(encounter: encounter),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),

                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      decoration: StyleWidget.cardDecoration(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  encounter.reason ?? S().general_consultation,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              _statusBadge(encounter.status),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            encounter.notes ?? S().no_additional_notes,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                                ),
                          ),
                          SizedBox(
                            height: 20.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EncounterDetailsView(
                                          encounter: encounter,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color statusColor = Constant.statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: statusColor.withAlpha((0.15 * 255).toInt()),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
