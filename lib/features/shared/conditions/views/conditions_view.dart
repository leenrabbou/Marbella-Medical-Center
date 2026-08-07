import 'package:marbella/app/app_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/codes/viewmodels/code_viewmodel.dart';
import 'package:marbella/features/shared/conditions/viewmodels/condition_viewmodel.dart';
import 'package:marbella/features/shared/conditions/widgets/condition_card.dart';
import 'package:marbella/features/shared/conditions/widgets/condition_dialogs.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ConditionsView extends StatefulWidget {
  const ConditionsView({
    super.key,
    required this.encounter,
    this.clinicalStatus,
    this.encounterId,
    this.patientId,
    required this.verificationStatus,
  });
  final EncounterModel? encounter;
  final String? clinicalStatus;
  final int? encounterId;
  final int? patientId;
  final String? verificationStatus;

  @override
  State<ConditionsView> createState() => _ConditionsViewState();
}

class _ConditionsViewState extends State<ConditionsView> {
  late String locale;
  String? token;

  late ConditionParams _params;
  @override
  void initState() {
    super.initState();

    _params = ConditionParams(
      encounterId: widget.encounterId,
      clinicalStatus: widget.clinicalStatus,
      verificationStatus: widget.verificationStatus,
      patientId: widget.patientId,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    locale = Localizations.localeOf(context).languageCode;

    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;
    final params = ConditionParams(
      encounterId: widget.encounter?.id,
      clinicalStatus: widget.clinicalStatus,
      verificationStatus: widget.verificationStatus,
      patientId: widget.patientId,
    );
    await context.read<ConditionViewmodel>().getEncounterConditions(
      locale,
      token,
      params,
    );

    if (!mounted) return;
    await context.read<CodeViewmodel>().getCodes(
      locale,
      token,
      CodeParams(active: 1, category: 'condition'),
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
    final role = context.read<AppRole>();
    final bool isEditable = widget.encounter?.status == 'in-progress';
    final colorScheme = Theme.of(context).colorScheme;
    final conditionsProvider = context.watch<ConditionViewmodel>();
    final conditions = conditionsProvider.conditionsFor(_params);
    bool isMobile = DeviceInfo.isMobile(context);
    return Scaffold(
      floatingActionButton: isEditable && role == AppRole.doctor
          ? FloatingActionButton(
              onPressed: () {
                ConditionDialogs().showConditionDialog(
                  context,
                  null,
                  patientId: widget.patientId ?? widget.encounter?.patient.id,
                  encounterId: widget.encounterId ?? widget.encounter?.id,
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
                conditionsProvider.isLoadingFor(_params) &&
                conditionsProvider.conditionsFor(_params).isEmpty,
            error: conditionsProvider.errorMessageFor(_params),
            isEmpty:
                !conditionsProvider.isLoadingFor(_params) &&
                conditionsProvider.errorMessageFor(_params) == null &&
                conditions.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 40.w : 20.w,
                vertical: isMobile ? 0.h : 5.h,
              ),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: conditions.length,
              itemBuilder: (BuildContext context, int index) {
                return ConditionCard(
                  condition: conditions[index],
                  isEditable: isEditable && role == AppRole.doctor,
                  onEdit: () {
                    ConditionDialogs().showConditionDialog(
                      context,
                      conditions[index],
                    );
                  },
                  onDelete: () {
                    ConditionDialogs().showDeleteConditionDialog(
                      context,
                      conditions[index],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
