import 'package:dropdown_search/dropdown_search.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';
import 'package:marbella/features/shared/codes/viewmodels/code_viewmodel.dart';
import 'package:marbella/features/shared/conditions/models/condition_model.dart';
import 'package:marbella/features/shared/conditions/viewmodels/condition_viewmodel.dart';
import 'package:marbella/features/shared/observations/widgets/observation_dialogs.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ConditionDialogs {
  Future<void> showConditionDialog(
    BuildContext context,
    ConditionModel? condition, {
    int? patientId,
    int? encounterId,
  }) async {
    final conditionProvider = context.read<ConditionViewmodel>();
    final isEditMode = condition != null;

    final noteController = TextEditingController(text: condition?.note ?? '');

    DateTime? onsetDate = condition != null
        ? DateTime.tryParse(condition.onsetDate)
        : DateTime.now();

    DateTime? abatementDate =
        condition?.abatementDate != null &&
            condition!.abatementDate!.trim().isNotEmpty
        ? DateTime.tryParse(condition.abatementDate!)
        : null;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int? selectedCode = condition?.code.id;
    String selectedClinicalStatus = condition?.clinicalStatus ?? 'active';
    String selectedVerificationStatus =
        condition?.verificationStatus ?? 'provisional';

    final clinicalStatuses = [
      "active",
      "recurrence",
      "inactive",
      "remission",
      "resolved",
    ];

    final verificationStatuses = [
      "provisional",
      "differential",
      "confirmed",
      "refuted",
      "entered-in-error",
    ];

    bool isSubmitting = false;
    String? localErrorMessage;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final codes = context.watch<CodeViewmodel>().getCodesByCategory(
              'condition',
            );
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditMode ? S().condition_edit : S().condition_add,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
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
                              color: Colors.red.withAlpha((0.3 * 255).toInt()),
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

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S().condition_type,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownSearch<CodeModel>(
                                  items: (filter, loadProps) => codes,
                                  compareFn: (a, b) => a.id == b.id,
                                  itemAsString: (item) => item.display,
                                  selectedItem: selectedCode == null
                                      ? null
                                      : codes
                                            .where((e) => e.id == selectedCode)
                                            .isNotEmpty
                                      ? codes.firstWhere(
                                          (e) => e.id == selectedCode,
                                        )
                                      : null,
                                  onSelected: (value) {
                                    if (value != null) {
                                      setState(() => selectedCode = value.id);
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
                                    dialogProps: DialogProps(
                                      contentPadding: EdgeInsetsGeometry.all(
                                        20,
                                      ),
                                      backgroundColor: colorScheme.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      actions: [
                                        CustomButtonWidget(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            onPressed: () {
                              ObservationDialogs().showAddCodeDialog(
                                context,
                                'condition',
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S().clinical_status,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedClinicalStatus,
                                  decoration:
                                      StyleWidget.buildDropdownInputDecoration(
                                        context,
                                      ),
                                  items: clinicalStatuses
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            Constant.statusLabel(e),
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(
                                        () => selectedClinicalStatus = v,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S().verification_status,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedVerificationStatus,
                                  decoration:
                                      StyleWidget.buildDropdownInputDecoration(
                                        context,
                                      ),
                                  items: verificationStatuses
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            Constant.statusLabel(e),
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(
                                        () => selectedVerificationStatus = v,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: onsetDate ?? DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => onsetDate = date);
                          }
                        },
                        child: IgnorePointer(
                          child: CustomTextField(
                            icon: Icons.play_circle_outline,
                            text: S().onset_date,
                            isPhone: false,
                            hint: onsetDate == null
                                ? S().choose_date
                                : "${onsetDate!.day}-${onsetDate!.month}-${onsetDate!.year}",
                            isValidation: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: abatementDate ?? DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => abatementDate = date);
                          }
                        },
                        child: IgnorePointer(
                          child: CustomTextField(
                            icon: Icons.check_circle_outline,
                            text: S().abatement_date,
                            isPhone: false,
                            hint: abatementDate == null
                                ? S().choose_date
                                : "${abatementDate!.day}-${abatementDate!.month}-${abatementDate!.year}",
                            isValidation: false,
                          ),
                        ),
                      ),
                      if (abatementDate != null)
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() => abatementDate = null);
                            },
                            icon: const Icon(Icons.clear, size: 16),
                            label: Text(
                              S().clear,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),

                      if (abatementDate == null) SizedBox(height: 10.h),
                      CustomTextField(
                        controller: noteController,
                        icon: Icons.description_outlined,
                        text: S().notes,
                        hint: S().enter_notes_hint,
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
                                : () {
                                    Navigator.pop(context);
                                  },
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
                                    if (selectedCode == null) {
                                      setState(() {
                                        localErrorMessage =
                                            S().select_condition_type;
                                      });
                                      return;
                                    }
                                    if (onsetDate == null) {
                                      setState(() {
                                        localErrorMessage =
                                            S().select_onset_date;
                                      });
                                      return;
                                    }
                                    if (!isEditMode &&
                                        (patientId == null ||
                                            encounterId == null)) {
                                      setState(() {
                                        localErrorMessage = S().something_wrong;
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
                                      final params = UpdateConditionParams(
                                        codeId: selectedCode!,
                                        clinicalStatus: selectedClinicalStatus,
                                        verificationStatus:
                                            selectedVerificationStatus,
                                        onsetDate: onsetDate.toString(),
                                        abatementDate: abatementDate
                                            ?.toString(),

                                        note: noteController.text,
                                      );
                                      success = await conditionProvider
                                          .updateCondition(
                                            params,
                                            condition.id,
                                            locale,
                                            token,
                                          );
                                    } else {
                                      final params = AddConditionParams(
                                        patientId: patientId!,
                                        encounterId: encounterId!,
                                        codeId: selectedCode!,
                                        clinicalStatus: selectedClinicalStatus,
                                        verificationStatus:
                                            selectedVerificationStatus,
                                        onsetDate: onsetDate.toString(),
                                        abatementDate: abatementDate
                                            ?.toString(),
                                        note: noteController.text,
                                      );
                                      success = await conditionProvider
                                          .addCondition(params, locale, token);
                                    }

                                    if (!context.mounted) return;

                                    if (success) {
                                      AppSnackbar.show(
                                        context,
                                        message: isEditMode
                                            ? S().condition_updated
                                            : S().condition_added,
                                        type: SnackbarType.success,
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        isSubmitting = false;
                                        localErrorMessage =
                                            (isEditMode
                                                ? conditionProvider
                                                      .updateErrorMessage
                                                : conditionProvider
                                                      .addErrorMessage) ??
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
                                ? SpinKitThreeInOut(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    S().save,
                                    style: theme.textTheme.bodyMedium?.copyWith(
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
            );
          },
        );
      },
    );
  }

  void showDeleteConditionDialog(
    BuildContext context,
    ConditionModel condition,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<ConditionViewmodel>(
          builder: (context, conditionProvider, child) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                S().delete_condition,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().condition_delete_warning,
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
                      onPressed: conditionProvider.deleteisLoading
                          ? () {}
                          : () {
                              Navigator.pop(dialogContext);
                            },
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
                      onPressed: conditionProvider.deleteisLoading
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

                              bool success = await conditionProvider
                                  .deleteCondition(condition.id, locale, token);

                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }

                              if (success) {
                                AppSnackbar.show(
                                  context,
                                  message: S().condition_deleted,
                                  type: SnackbarType.success,
                                );
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      conditionProvider.deleteErrorMessage ??
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
                      child: conditionProvider.deleteisLoading
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
