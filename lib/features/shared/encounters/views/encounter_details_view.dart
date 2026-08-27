import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/helper/secure_screen_controller.dart';
import 'package:marbella/features/only_doctor/audit/views/audit_view.dart';
import 'package:marbella/features/only_doctor/patients/views/patient_info_view.dart';
import 'package:marbella/features/shared/encounter_services/views/encounter_service_tab.dart';
import 'package:marbella/features/shared/encounters/views/encounter_notes_tab.dart';
import 'package:marbella/features/only_doctor/nurses/views/nurses_view.dart';
import 'package:marbella/features/shared/patient_medications/views/patient_medication_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/conditions/views/conditions_view.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';
import 'package:marbella/features/shared/encounters/views/over_view_encounter_tab.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_viewmodel.dart';
import 'package:marbella/features/shared/observations/views/observation_view.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class EncounterDetailsView extends StatefulWidget {
  const EncounterDetailsView({
    super.key,
    required this.encounter,
    required this.isFromPatientView,
  });

  final EncounterModel encounter;
  final bool isFromPatientView;

  @override
  State<EncounterDetailsView> createState() => _EncounterDetailsViewState();
}

class _EncounterDetailsViewState extends State<EncounterDetailsView>
    with TickerProviderStateMixin, SecureScreenMixin<EncounterDetailsView> {
  late TextEditingController reasonController;
  late TextEditingController notesController;

  final List<TextEditingController> diagnosisControllers = [];
  late EncounterModel localeEncounter;
  late TabController _tabController;

  bool hasChanges = false;
  bool edit = true;

  bool get isEditable => localeEncounter.status.toLowerCase() == 'in-progress';
  @override
  void initState() {
    super.initState();
    final role = context.read<AppRole>();
    _tabController = TabController(
      length: role == AppRole.doctor ? 7 : 6,
      vsync: this,
    );
    localeEncounter = widget.encounter;
    reasonController = TextEditingController();
    notesController = TextEditingController();
    reasonController.addListener(_onChanged);
    notesController.addListener(_onChanged);
  }

  String? get _token =>
      context.read<AuthViewmodel>().response?.data?.token ??
      context.read<AuthViewmodel>().userFromCache?.data?.token;

  String get _locale => Localizations.localeOf(context).languageCode;

  void _onChanged() {
    if (!hasChanges) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !hasChanges) {
          setState(() => hasChanges = true);
        }
      });
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    notesController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final role = context.read<AppRole>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 15),
        ),
        title: const SizedBox.shrink(),
        actions: [
          if (role == AppRole.doctor && !widget.isFromPatientView)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientInfoView(
                      patient: widget.encounter.patient,                      
                    ),
                  ),
                );
              },
              child: Text(
                S().view_patient_info,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          if (role == AppRole.doctor)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AuditView(
                      id: widget.encounter.id,
                      endPoint: EndPoints.encounter,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.manage_history_rounded),
            ),
        ],
      ),
      bottomNavigationBar: isEditable && edit
          ? SafeArea(child: _bottomActionsBar(colorScheme))
          : null,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurface.withAlpha(
                      (0.6 * 255).toInt(),
                    ),
                    controller: _tabController,

                    labelStyle: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    tabs: [
                      Tab(text: S().overview),
                      Tab(text: S().observations),
                      Tab(text: S().conditions),
                      Tab(text: S().medications_tab),
                      Tab(text: S().services),
                      Tab(text: S().notes),
                      if (role == AppRole.doctor) Tab(text: S().nurses),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,

                    children: [
                      OverViewEncounterTab(
                        isEditable: isEditable,
                        reasonController: reasonController,
                        notesController: notesController,
                        encounter: localeEncounter,
                      ),
                      ObservationView(encounter: widget.encounter),
                      ConditionsView(
                        encounter: localeEncounter,
                        clinicalStatus: null,
                        encounterId: localeEncounter.id,
                        verificationStatus: null,
                      ),
                      PatientMedicationView(
                        isEditable: isEditable,
                        encounterId: localeEncounter.id,
                        patientId: localeEncounter.patient.id,
                        status: null,
                      ),
                      EncounterServiceTab(
                        isEditable: isEditable,
                        encounterId: localeEncounter.id,
                        status: null,
                      ),
                      EncounterNotesTab(
                        isEditable: isEditable,
                        encounterId: localeEncounter.id,
                        patientId: localeEncounter.patient.id,
                        status: null,
                      ),
                      if (role == AppRole.doctor)
                        NursesView(
                          isEditable: isEditable,
                          encounterId: localeEncounter.id,
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bottomActionsBar(ColorScheme colorScheme) {
    final encounter = context.watch<EncounterViewmodel>();
    final role = context.read<AppRole>();
    bool isMobile = DeviceInfo.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 40.w : 20.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, -3),
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButtonWidget(
              onPressed: () {
                _discard();
              },
              height: isMobile ? 30.h : 40.h,
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              color: colorScheme.surface,
              width: 0,
              textSize: 20,
              elevation: 0,
              textColor: Colors.white,
              child: Text(
                S().discard,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: 15.w),
          Expanded(
            child: CustomButtonWidget(
              onPressed: encounter.isLoadingUpdate
                  ? null
                  : () {
                      _saveChanges(null);
                    },
              height: isMobile ? 30.h : 40.h,
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              color: Theme.of(context).colorScheme.primary,
              width: 0,
              textSize: 20,
              elevation: 0,
              textColor: Colors.white,
              child: encounter.isLoadingUpdate
                  ? const SpinKitThreeInOut(color: Colors.white, size: 20)
                  : Text(
                      S().save_changes,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          if (role == AppRole.doctor) ...[
            SizedBox(width: 15.w),
            Expanded(
              child: CustomButtonWidget(
                onPressed: _finishVisit,
                height: 40.h,
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                color: Constant.statusColor(
                  widget.encounter.status,
                ).withAlpha((0.8 * 255).toInt()),
                width: 0,
                textSize: 20,
                elevation: 0,
                textColor: Colors.white,
                child: Text(
                  S().terminate_session,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveChanges(String? status) async {
    final encounter = context.read<EncounterViewmodel>();
    UpdateEncounterParams params = UpdateEncounterParams(
      reason: reasonController.text,
      status: status,
      notes: notesController.text,
    );
    await encounter.updateEncounter(
      params,
      widget.encounter.id,
      _locale,
      _token,
    );

    if (encounter.isUpdateSuccessfully) {
      AppSnackbar.show(
        context,
        message: S().save_changes_success,
        type: SnackbarType.success,
      );
    } else {
      AppSnackbar.show(
        context,
        message: encounter.errorMessageUpdate ?? S().unknown_error,
        type: SnackbarType.error,
      );
    }
    reasonController.clear();
    notesController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      hasChanges = false;
    });
  }

  Future<void> _finishVisit() async {
    final encounter = context.read<EncounterViewmodel>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        ColorScheme colorScheme = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                S().finish_visit,

                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: colorScheme.primary),
                textAlign: TextAlign.center,
              ),

              content: SizedBox(
                width: DeviceInfo.width(context) * 0.3,
                child: Text(
                  S().finish_visit_confirm,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      height: 40,
                      width: 140,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 15,
                      color: Theme.of(context).colorScheme.surface,
                      textColor: colorScheme.primary,
                      elevation: 0,
                      child: Text(
                        S().cancel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    CustomButtonWidget(
                      onPressed: encounter.isLoadingUpdate
                          ? null
                          : () {
                              setState(() {
                                hasChanges = false;
                                edit = false;
                              });
                              _saveChanges('finished');
                              Navigator.pop(context);
                            },
                      height: 40,
                      width: 140,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 18,
                      color: colorScheme.primary,
                      elevation: 3,
                      textColor: Colors.white,
                      child: encounter.isLoadingUpdate
                          ? const SpinKitThreeInOut(
                              color: Colors.white,
                              size: 20,
                            )
                          : Text(
                              S().finish_button,

                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm == true) {
      setState(() {
        localeEncounter = EncounterModel(
          id: localeEncounter.id,
          patient: localeEncounter.patient,
          startTime: localeEncounter.startTime,
          endTime: localeEncounter.endTime,
          status: 'finished',
          notes: localeEncounter.notes,
          reason: localeEncounter.reason,
          doctor: localeEncounter.doctor,
        );
      });
    }
  }

  Future<void> _discard() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool isMobile = DeviceInfo.isMobile(context);
        ColorScheme colorScheme = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: SizedBox(
                width: DeviceInfo.width(context) * 0.3,
                child: Text(
                  S().discard_changes,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: () {
                        reasonController.clear();
                        notesController.clear();
                        Navigator.pop(context);
                      },
                      height: 40.h,
                      width: isMobile ? 300.w : 140.w,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 15,
                      color: Theme.of(context).colorScheme.surface,
                      textColor: colorScheme.primary,
                      elevation: 0,
                      child: Text(
                        S().discard,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    CustomButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      height: 40.h,
                      width: isMobile ? 350.w : 140.w,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 18,
                      color: colorScheme.primary,
                      elevation: 3,
                      textColor: Colors.white,
                      child: Text(
                        S().keep_editing,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm == true) {
      setState(() {
        localeEncounter = EncounterModel(
          id: localeEncounter.id,
          patient: localeEncounter.patient,
          startTime: localeEncounter.startTime,
          endTime: localeEncounter.endTime,
          status: 'finished',
          notes: localeEncounter.notes,
          reason: localeEncounter.reason,
          doctor: localeEncounter.doctor,
        );
      });
    }
  }
}
