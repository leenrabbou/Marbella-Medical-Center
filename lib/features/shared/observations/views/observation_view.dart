import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/codes/viewmodels/code_viewmodel.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';
import 'package:marbella/features/shared/observations/viewmodels/observation_viewmodel.dart';
import 'package:marbella/features/shared/observations/widgets/observation_card.dart';
import 'package:marbella/features/shared/observations/widgets/observation_dialogs.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ObservationView extends StatefulWidget {
  const ObservationView({super.key, required this.encounter});
  final EncounterModel encounter;

  @override
  State<ObservationView> createState() => _ObservationViewState();
}

class _ObservationViewState extends State<ObservationView> {
  final TextEditingController searchController = TextEditingController();
  late String locale;
  String? token;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    locale = Localizations.localeOf(context).languageCode;

    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;

    ObservationParams params = ObservationParams(
      encounterId: widget.encounter.id,
      status: null,
      patientId: widget.encounter.patient.id,
    );

    if (token == null) return;

    await context.read<ObservationViewmodel>().getobservations(
      locale,
      token,
      params,
    );
    if (!mounted) return;
    await context.read<CodeViewmodel>().getCodes(
      locale,
      token,
      CodeParams(active: 1, category: 'observation'),
    );
  }

  Future<void> _handleRefresh() async {
    await _fetchData();
  }

  String safeText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S().not_available;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditable = widget.encounter.status == 'in-progress';
    final colorScheme = Theme.of(context).colorScheme;
    final observationsProvider = context.watch<ObservationViewmodel>();
    final observations = observationsProvider.observations;
    bool isMobile = DeviceInfo.isMobile(context);
    return Scaffold(
      floatingActionButton: isEditable
          ? FloatingActionButton(
              onPressed: () {
                ObservationDialogs().showEditObservationDialog(
                  context,
                  null,
                  widget.encounter.id,
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            )
          : null,
      body: LiquidPullToRefresh(
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        onRefresh: _handleRefresh,
        child: Center(
          child: StateWidget(
            isLoading:
                observationsProvider.isLoading &&
                observationsProvider.observations.isEmpty,
            error: observationsProvider.errorMessage,
            isEmpty:
                !observationsProvider.isLoading &&
                observationsProvider.errorMessage == null &&
                observations.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 40.w : 20.w,
                vertical: isMobile ? 0.h : 5.h,
              ),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: observations.length,
              itemBuilder: (BuildContext context, int index) {
                return ObservationCard(
                  observation: observations[index],
                  isEditable: isEditable,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
