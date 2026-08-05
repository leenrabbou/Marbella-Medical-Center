import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';
import 'package:provider/provider.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/only_doctor/appointments/viewmodels/appointments_viewmodel.dart';
import 'package:marbella/features/only_doctor/appointments/widgets/appointment_card.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';

class AppointmentsTabContent extends StatefulWidget {
  final String noDataMessage;
  final String status;
  final String? dateRangeFrom;
  final String? dateRangeTo;
  final int? patientId;
  final String? search;
  final bool isFromPatient;

  const AppointmentsTabContent({
    super.key,
    required this.noDataMessage,
    required this.status,
    required this.dateRangeFrom,
    required this.dateRangeTo,
    required this.isFromPatient,
    this.patientId,
    this.search,
  });

  @override
  State<AppointmentsTabContent> createState() => _AppointmentsTabContentState();
}

class _AppointmentsTabContentState extends State<AppointmentsTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? _lastFetchedKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchIfNeeded());
  }

  @override
  void didUpdateWidget(covariant AppointmentsTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final filtersChanged =
        oldWidget.dateRangeFrom != widget.dateRangeFrom ||
        oldWidget.dateRangeTo != widget.dateRangeTo ||
        oldWidget.patientId != widget.patientId ||
        oldWidget.search != widget.search;

    if (filtersChanged) {
      _fetchIfNeeded(force: true);
    }
  }

  String get _apiStatus => widget.status == 'all' ? '' : widget.status;

  String get _currentKey =>
      '${widget.status}|${widget.dateRangeFrom}|${widget.dateRangeTo}|${widget.patientId}|${widget.search}';

  Future<void> _fetchIfNeeded({bool force = false}) async {
    if (!mounted) return;

    final key = _currentKey;
    if (!force && _lastFetchedKey == key) {
      return;
    }

    final locale = Localizations.localeOf(context).languageCode;
    final token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;

    final params = AppointmentsParams(
      search: widget.search,
      status: _apiStatus.isEmpty ? null : _apiStatus,
      dateRangeFrom: widget.dateRangeFrom,
      dateRangeTo: widget.dateRangeTo,
      patientId: widget.patientId,
    );

    await context.read<AppointmentsViewmodel>().getAppointmentsList(
      locale,
      token,
      params,
    );

    _lastFetchedKey = key;
  }

  Future<void> _handleRefresh() => _fetchIfNeeded(force: true);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appointmentProvider = context.watch<AppointmentsViewmodel>();
    final colorScheme = Theme.of(context).colorScheme;

    final List<AppointmentModel> targetList = appointmentProvider
        .getAppointmentsListByStatus(widget.status);

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
      backgroundColor: colorScheme.surface,
      height: 50,
      child: StateWidget(
        isLoading: appointmentProvider.isLoadingByStatus(widget.status),
        error: appointmentProvider.errorByStatus(widget.status),
        isEmpty:
            !appointmentProvider.isLoadingByStatus(widget.status) &&
            targetList.isEmpty &&
            appointmentProvider.errorByStatus(widget.status) == null,
        onRetry: _handleRefresh,
        noDataMsg: widget.noDataMessage,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: targetList.length,
          itemBuilder: (context, index) {
            return AppointmentCard(
              appointment: targetList[index],
              isFromPatient: widget.isFromPatient,
            );
          },
        ),
      ),
    );
  }
}
