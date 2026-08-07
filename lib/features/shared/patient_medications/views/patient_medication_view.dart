import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/medication_viewmodel.dart';
import 'package:marbella/features/shared/patient_medications/viewmodel/patient_medication_viewmodel.dart';
import 'package:marbella/features/shared/patient_medications/widgets/patient_medication_card.dart';
import 'package:marbella/features/shared/patient_medications/widgets/patient_medication_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class PatientMedicationView extends StatefulWidget {
  const PatientMedicationView({
    super.key,
    required this.isEditable,
    required this.encounterId,
    required this.patientId,
    required this.status,
  });
  final bool isEditable;
  final int? patientId;
  final int? encounterId;
  final String? status;
  @override
  State<PatientMedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<PatientMedicationView> {
  late String locale;
  String? token;
  late PatientMedicationsParams _params;
  @override
  @override
  void initState() {
    super.initState();

    _params = PatientMedicationsParams(
      patientId: widget.patientId,
      doctorId: null,
      encounterId: widget.encounterId,
      status: widget.status,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    locale = Localizations.localeOf(context).languageCode;

    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;

    if (!mounted || token == null) return;

    await context.read<PatientMedicationViewmodel>().getPatientMedications(
      locale,
      token!,
      _params,
    );

    if (!mounted) return;

    await context.read<MedicationViewmodel>().getMedications(locale, token!);
  }

  Future<void> _handleRefresh() async {
    if (!mounted) return;
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
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<PatientMedicationViewmodel>();
    final medications = provider.medicationsFor(_params);
    final isLoading = provider.isLoadingFor(_params);
    final errorMessage = provider.errorMessageFor(_params);
    final role = context.read<AppRole>();
    bool isMobile = DeviceInfo.isMobile(context);
    return Scaffold(
      floatingActionButton: widget.isEditable && role == AppRole.doctor
          ? FloatingActionButton(
              onPressed: () {
                PatientMedicationDialogs.showPatientMedicationDialog(
                  context,
                  null,
                  patientId: widget.patientId,
                  encounterId: widget.encounterId,
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
            isLoading: isLoading && medications.isEmpty,
            error: errorMessage,
            isEmpty: !isLoading && errorMessage == null && medications.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 40.w : 20.w,
                vertical: isMobile ? 0.h : 5.h,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: medications.length,
              itemBuilder: (BuildContext context, int index) {
                return PatientMedicationCard(
                  patientMedication: medications[index],
                  onEdit: () {
                    PatientMedicationDialogs.showPatientMedicationDialog(
                      context,
                      medications[index],
                    );
                  },
                  onDelete: () {
                    PatientMedicationDialogs.showDeletePatientMedicationDialog(
                      context,
                      medications[index],
                    );
                  },
                  isEditable: widget.isEditable,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
