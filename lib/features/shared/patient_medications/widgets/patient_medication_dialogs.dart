import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/models/drug_interaction_model.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/medication_viewmodel.dart';
import 'package:marbella/features/shared/patient_medications/viewmodel/patient_medication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medication_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class PatientMedicationDialogs {
  static Future<void> showPatientMedicationDialog(
    BuildContext context,
    PatientMedicationModel? patientMedication, {
    int? patientId,
    int? encounterId,
  }) async {
    final patientMedicationProvider = context
        .read<PatientMedicationViewmodel>();
    final medicationProvider = context.read<MedicationViewmodel>();
    final isEditMode = patientMedication != null;
    final formKey = GlobalKey<FormState>();
    final dosageController = TextEditingController();
    final routeController = TextEditingController();
    final durationValueController = TextEditingController();
    final notesController = TextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int? selectedMedicationId = patientMedication?.medication.id;
    String selectedDurationUnit = patientMedication?.durationUnit ?? 'days';
    final durationUnits = ['days', 'weeks', 'months'];
    bool isSubmitting = false;
    String? localErrorMessage;
    bool isMedicationSelected = false;
    bool isUnitSelected = false;

    if (medicationProvider.mediactionsList.isEmpty &&
        !medicationProvider.isLoadingList) {
      final locale = Localizations.localeOf(context).languageCode;
      final token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      medicationProvider.getMedications(locale, token);
    }

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final medsProvider = context.watch<MedicationViewmodel>();
            final medications = medsProvider.mediactionsList;
            final isMedsLoading = medsProvider.isLoadingList;
            final medsError = medsProvider.getListErrorMessage;

            return Dialog(
              backgroundColor: colorScheme.surface,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 700,
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditMode
                              ? S().edit_patient_medication
                              : S().add_patient_medication,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            height: 0.5,
                            color: colorScheme.onSurface.withAlpha(
                              (0.1 * 255).toInt(),
                            ),
                          ),
                        ),
                        if (localErrorMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha((0.1 * 255).toInt()),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.red.withAlpha(
                                  (0.3 * 255).toInt(),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    localErrorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          S().medication,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),

                        if (isMedsLoading && medications.isEmpty)
                          Container(
                            height: 52,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface.withAlpha(
                                (0.03 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: SpinKitFadingGrid(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  S().loading_medications,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(
                                      (0.5 * 255).toInt(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (medsError != null && medications.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha(
                                (0.08 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.wifi_off_outlined,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    medsError,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final locale = Localizations.localeOf(
                                      context,
                                    ).languageCode;
                                    final token =
                                        context
                                            .read<AuthViewmodel>()
                                            .response
                                            ?.data
                                            ?.token ??
                                        context
                                            .read<AuthViewmodel>()
                                            .userFromCache
                                            ?.data
                                            ?.token;
                                    medsProvider.getMedications(locale, token);
                                  },
                                  child: Text(S().retry),
                                ),
                              ],
                            ),
                          )
                        else
                          DropdownSearch<MedicationModel>(
                            items: (filter, loadProps) => medications,
                            compareFn: (a, b) => a.id == b.id,
                            itemAsString: (item) => item.code.display,
                            selectedItem: selectedMedicationId == null
                                ? null
                                : medications
                                      .where(
                                        (e) => e.id == selectedMedicationId,
                                      )
                                      .isNotEmpty
                                ? medications.firstWhere(
                                    (e) => e.id == selectedMedicationId,
                                  )
                                : null,
                            onSelected: (value) {
                              if (value != null) {
                                setState(() => selectedMedicationId = value.id);
                                isMedicationSelected = true;
                              }
                            },
                            decoratorProps: DropDownDecoratorProps(
                              decoration:
                                  StyleWidget.buildDropdownInputDecoration(
                                    context,
                                  ),
                            ),
                            popupProps: PopupProps.dialog(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration:
                                    StyleWidget.buildDropdownInputDecoration(
                                      context,
                                      icons: true,
                                    ),
                              ),
                              itemBuilder:
                                  (context, item, isDisabled, isSelected) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.medication_outlined,
                                            size: 18,
                                            color: colorScheme.primary,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              item.code.display,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                              dialogProps: DialogProps(
                                contentPadding: const EdgeInsets.all(20),
                                backgroundColor: colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                actions: [
                                  CustomButtonWidget(
                                    onPressed: () => Navigator.pop(context),
                                    height: 40,
                                    width: 120,
                                    left: 0,
                                    right: 0,
                                    top: 5,
                                    bottom: 0,
                                    textSize: 15,
                                    color: colorScheme.surface,
                                    textColor: colorScheme.primary,
                                    elevation: 0,
                                    child: Text(
                                      S().cancel,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: dosageController,
                                icon: Icons.medication_liquid_outlined,
                                text: S().medication_dosage,
                                hint: isEditMode
                                    ? patientMedication.dosage
                                    : S().enter_dosage_hint,
                                isPhone: false,
                                isValidation: !isEditMode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                controller: routeController,
                                icon: Icons.alt_route_outlined,
                                text: S().route,
                                hint: isEditMode
                                    ? patientMedication.route
                                    : S().enter_route_hint,
                                isPhone: false,
                                isValidation: !isEditMode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: durationValueController,
                                icon: Icons.timelapse_outlined,
                                text: S().duration,
                                hint: isEditMode
                                    ? patientMedication.durationValue.toString()
                                    : S().enter_duration_hint,
                                isPhone: false,
                                isValidation: !isEditMode,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                type: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S().unit,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue: selectedDurationUnit,
                                    decoration:
                                        StyleWidget.buildDropdownInputDecoration(
                                          context,
                                        ),
                                    items: durationUnits
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              Constant.unitLabel(e),
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          selectedDurationUnit = v;
                                          isUnitSelected = true;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: notesController,
                          icon: Icons.description_outlined,
                          text: S().notes,
                          hint: isEditMode
                              ? patientMedication.notes ?? S().enter_note_hint
                              : S().enter_note_hint,
                          isValidation: false,
                          isPhone: false,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButtonWidget(
                              onPressed: isSubmitting
                                  ? () {}
                                  : () => Navigator.pop(context),
                              height: 40,
                              width: 120,
                              left: 40,
                              right: 40,
                              top: 5,
                              bottom: 0,
                              textSize: 15,
                              color: colorScheme.surface,
                              textColor: colorScheme.primary,
                              elevation: 0,
                              child: Text(
                                S().cancel,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            CustomButtonWidget(
                              onPressed: isSubmitting
                                  ? () {}
                                  : () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }
                                      if (selectedMedicationId == null &&
                                          !isEditMode) {
                                        setState(() {
                                          localErrorMessage =
                                              S().select_medication;
                                        });
                                        return;
                                      }
                                      final durationValue = int.tryParse(
                                        durationValueController.text,
                                      );
                                      if (durationValue == null &&
                                          !isEditMode) {
                                        setState(() {
                                          localErrorMessage =
                                              S().valid_duration;
                                        });
                                        return;
                                      }
                                      setState(() {
                                        isSubmitting = true;
                                        localErrorMessage = null;
                                      });
                                      final locale = Localizations.localeOf(
                                        context,
                                      ).languageCode;
                                      final token =
                                          context
                                              .read<AuthViewmodel>()
                                              .response
                                              ?.data
                                              ?.token ??
                                          context
                                              .read<AuthViewmodel>()
                                              .userFromCache
                                              ?.data
                                              ?.token;
                                      bool success;
                                      if (isEditMode) {
                                        final params =
                                            UpdatePatientMedicationParams(
                                              medicationId: isMedicationSelected
                                                  ? selectedMedicationId!
                                                  : null,
                                              dosage: dosageController.text,
                                              route: routeController.text,
                                              durationValue: durationValue,
                                              durationUnit: isUnitSelected
                                                  ? selectedDurationUnit
                                                  : null,
                                              notes: notesController.text,
                                            );
                                        success =
                                            await patientMedicationProvider
                                                .updatePatientMedication(
                                                  params,
                                                  patientMedication.id,
                                                  locale,
                                                  token,
                                                );
                                      } else {
                                        final params =
                                            AddPatientMedicationParams(
                                              encounterId: encounterId!,
                                              medicationId:
                                                  selectedMedicationId!,
                                              dosage: dosageController.text,
                                              route: routeController.text,
                                              durationValue: durationValue,
                                              durationUnit:
                                                  selectedDurationUnit,
                                              notes: notesController.text,
                                              override: 0,
                                            );
                                        success =
                                            await patientMedicationProvider
                                                .addMedication(
                                                  params,
                                                  locale,
                                                  token,
                                                );
                                      }
                                      if (!context.mounted) return;
                                      if (success) {
                                        Navigator.pop(context);
                                        WidgetsBinding.instance.addPostFrameCallback((
                                          _,
                                        ) {
                                          AppSnackbar.show(
                                            context,
                                            message: isEditMode
                                                ? S().medication_updated_successfully
                                                : S().medication_added_successfully,
                                            type: SnackbarType.success,
                                          );
                                        });
                                      } else if (patientMedicationProvider
                                              .medicationConflictInteractions !=
                                          null) {
                                        setState(() => isSubmitting = false);
                                        final continueAnyway =
                                            await _showConflictDialog(
                                              context,
                                              patientMedicationProvider
                                                      .conflictMessage ??
                                                  S().medication_conflict_warning,
                                              patientMedicationProvider
                                                  .medicationConflictInteractions!,
                                            );
                                        if (continueAnyway == 1 &&
                                            context.mounted) {
                                          setState(() => isSubmitting = true);
                                          final forcedParams =
                                              AddPatientMedicationParams(
                                                encounterId: encounterId!,
                                                medicationId:
                                                    selectedMedicationId!,
                                                dosage: dosageController.text,
                                                route: routeController.text,
                                                durationValue: durationValue,
                                                durationUnit:
                                                    selectedDurationUnit,
                                                notes: notesController.text,
                                                override: 1,
                                              );
                                          final forcedSuccess =
                                              await patientMedicationProvider
                                                  .addMedication(
                                                    forcedParams,
                                                    locale,
                                                    token,
                                                  );
                                          if (!context.mounted) return;
                                          if (forcedSuccess) {
                                            Navigator.pop(context);
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                  AppSnackbar.show(
                                                    context,
                                                    message: S()
                                                        .medication_added_successfully,
                                                    type: SnackbarType.success,
                                                  );
                                                });
                                          } else {
                                            setState(() {
                                              isSubmitting = false;
                                              localErrorMessage =
                                                  patientMedicationProvider
                                                      .addErrorMessage ??
                                                  S().error;
                                            });
                                          }
                                        }
                                      } else {
                                        setState(() {
                                          isSubmitting = false;
                                          localErrorMessage =
                                              patientMedicationProvider
                                                  .addErrorMessage ??
                                              S().error;
                                        });
                                      }
                                    },
                              height: 40,
                              width: 120,
                              left: 40,
                              right: 40,
                              top: 5,
                              bottom: 0,
                              textSize: 18,
                              color: colorScheme.primary,
                              elevation: 3,
                              textColor: Colors.white,
                              child: isSubmitting
                                  ? const SpinKitThreeInOut(
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Text(
                                      S().save,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<int?> _showConflictDialog(
    BuildContext context,
    String message,
    List<DrugInteractionModel> interactions,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text(S().medication_conflict_title),
            ],
          ),
          content: SizedBox(
            width: 500.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                ...interactions.map(
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: Constant.statusColor(i.severity),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${i.drugInteraction.code.display} (${i.severity})",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CustomButtonWidget(
              onPressed: () => Navigator.pop(dialogContext, 0),
              height: 40,
              width: 120,
              left: 0,
              right: 0,
              top: 5,
              bottom: 0,
              textSize: 15,
              color: colorScheme.surface,
              textColor: colorScheme.primary,
              elevation: 0,
              child: Text(S().cancel, style: theme.textTheme.bodySmall),
            ),
            CustomButtonWidget(
              onPressed: () => Navigator.pop(dialogContext, 1),
              height: 40,
              width: 160,
              left: 0,
              right: 0,
              top: 5,
              bottom: 0,
              textSize: 18,
              color: Colors.redAccent,
              elevation: 3,
              textColor: Colors.white,

              child: Text(
                S().continue_anyway,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showDeletePatientMedicationDialog(
    BuildContext context,
    PatientMedicationModel patientMedication,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<PatientMedicationViewmodel>(
          builder: (context, patientMedicationProvider, child) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                S().delete_medication,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().medication_delete_warning,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    S().are_you_sure_continue,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: patientMedicationProvider.deleteisLoading
                          ? () {}
                          : () => Navigator.pop(dialogContext),
                      height: 40,
                      width: 120,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 15,
                      color: colorScheme.surface,
                      textColor: colorScheme.primary,
                      elevation: 0,
                      child: Text(
                        S().cancel,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    CustomButtonWidget(
                      onPressed: patientMedicationProvider.deleteisLoading
                          ? () {}
                          : () async {
                              final locale = Localizations.localeOf(
                                context,
                              ).languageCode;
                              final token =
                                  context
                                      .read<AuthViewmodel>()
                                      .response
                                      ?.data
                                      ?.token ??
                                  context
                                      .read<AuthViewmodel>()
                                      .userFromCache
                                      ?.data
                                      ?.token;
                              bool success = await patientMedicationProvider
                                  .deleteMedication(
                                    patientMedication.id,
                                    locale,
                                    token,
                                  );
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                              if (success) {
                                AppSnackbar.show(
                                  context,
                                  message: S().medication_deleted_successfully,
                                  type: SnackbarType.success,
                                );
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      patientMedicationProvider
                                          .deleteErrorMessage ??
                                      S().error,
                                  type: SnackbarType.error,
                                );
                              }
                            },
                      height: 40,
                      width: 120,
                      left: 0,
                      right: 0,
                      top: 5,
                      bottom: 0,
                      textSize: 18,
                      color: Colors.redAccent,
                      elevation: 3,
                      textColor: Colors.white,
                      child: patientMedicationProvider.deleteisLoading
                          ? const SpinKitThreeInOut(
                              color: Colors.white,
                              size: 20,
                            )
                          : Text(
                              S().delete,
                              style: theme.textTheme.bodyMedium?.copyWith(
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
  }
}
