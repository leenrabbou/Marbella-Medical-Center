import 'dart:typed_data';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/only_doctor/lab_tests/view/lab_test_tab.dart';
import 'package:marbella/features/shared/patient_medications/views/patient_medication_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/appointments/viewmodels/appointments_viewmodel.dart';
import 'package:marbella/features/only_doctor/appointments/views/appointment_view.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/conditions/views/conditions_view.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/features/only_doctor/patients/viewmodels/patients_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/views/encounters_tab.dart';
import 'package:marbella/features/only_doctor/patients/views/overview_tab.dart';
import 'package:marbella/features/only_doctor/patients/widgets/patient_header_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class PatientInfoView extends StatefulWidget {
  const PatientInfoView({super.key, required this.patient, this.img});
  final PatientModel patient;
  final Uint8List? img;
  @override
  State<PatientInfoView> createState() => _PatientInfoViewState();
}

class _PatientInfoViewState extends State<PatientInfoView> {
  late PatientModel localPatient;
  @override
  void initState() {
    super.initState();
    localPatient = widget.patient;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchEncounterData();
      _fetchAppointmentData();
    });
  }

  String? get _token =>
      context.read<AuthViewmodel>().response?.data?.token ??
      context.read<AuthViewmodel>().userFromCache?.data?.token;
  String get _locale => Localizations.localeOf(context).languageCode;
  Future<void> _fetchEncounterData() async {
    if (!mounted) return;
    await context.read<EncounterViewmodel>().refreshToFetchDataList(
      _locale,
      _token,
      EncounterParams(search: null, status: null, patientId: localPatient.id),
    );
  }

  Future<void> _fetchAppointmentData() async {
    if (!mounted) return;
    await context.read<AppointmentsViewmodel>().getAppointmentsList(
      _locale,
      _token,
      AppointmentsParams(
        search: null,
        status: 'booked',
        patientId: localPatient.id,
        dateRangeFrom: null,
        dateRangeTo: null,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await context.read<PatientsViewmodel>().getPatientDetails(
      _locale,
      _token,
      localPatient.id,
    );
    await _fetchEncounterData();
    await _fetchAppointmentData();
    if (mounted) {
      setState(() {
        localPatient =
            context.read<PatientsViewmodel>().patientDetails ?? localPatient;
      });
    }
  }

  void _openAppointments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 15),
            ),
            title: const SizedBox.shrink(),
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: AppointmentView(
              dateRangeFrom: null,
              dateRangeTo: null,
              patientId: localPatient.id,
              isFromPatient: true,
            ),
          ),
        ),
      ),
    );
  }

  void _openLabTests() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 15),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: LabTestTab(
              patientId: widget.patient.id,
              status: null,
              isRequest: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(theme, colorScheme),
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
          backgroundColor: colorScheme.surface,
          height: 50,
          child: DefaultTabController(
            length: 5,
            child: Column(
              children: [
                PatientHeaderWidget(
                  patient: localPatient,
                  initialImgBytes: widget.img,
                ),
                SizedBox(height: 10.h),
                _buildTabBar(colorScheme),
                Expanded(
                  child: TabBarView(
                    children: [
                      OverviewTab(patient: localPatient),
                      EncountersTab(status: null, patientId: localPatient.id),
                      ConditionsView(
                        encounter: null,
                        clinicalStatus: 'active',
                        patientId: localPatient.id,
                        verificationStatus: null,
                      ),
                      PatientMedicationView(
                        isEditable: false,
                        encounterId: null,
                        patientId: widget.patient.id,
                        status: 'active',
                      ),
                      LabTestTab(
                        patientId: widget.patient.id,
                        status: 'completed',
                        isRequest: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, size: 15),
      ),
      title: const SizedBox.shrink(),
      actions: [
        Tooltip(
          message: S().appointments,
          child: IconButton(
            onPressed: _openAppointments,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ),
        Tooltip(
          message: S().appointments,
          child: IconButton(
            onPressed: _openLabTests,
            icon: const Icon(Icons.note_add_outlined),
          ),
        ),
        SizedBox(width: 15.w),
      ],
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme) {
    bool isMobile = DeviceInfo.isMobile(context);
    final tabs = [
      (icon: Icons.dashboard_outlined, label: S().overview),
      (icon: Icons.local_hospital_outlined, label: S().encounters),
      (icon: Icons.medication_outlined, label: S().conditions),
      (icon: Icons.medication_outlined, label: S().medications_tab),
      (icon: Icons.science_outlined, label: S().labs_tests),
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha((0.07 * 255).toInt()),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: colorScheme.surface,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
        ),
        tabs: tabs
            .map(
              (t) => Tab(
                height: isMobile ? 20.h : 32.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(t.icon, size: 16),
                    SizedBox(width: 5.w),
                    Text(t.label),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
