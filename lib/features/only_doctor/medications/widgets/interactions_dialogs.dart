import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/interaction_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/medication_viewmodel.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';
import 'package:marbella/features/shared/codes/viewmodels/code_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class InteractionsDialogs {
  static Future<void> showAddInteractionsDialog(
    BuildContext context, {
    required int medicationId,
    required String interactableType,
  }) async {
    final provider = context.read<MedicationViewmodel>();
    final provider2 = context.read<CodeViewmodel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (provider.mediactionsList.isEmpty) {
      await provider.getMedications(locale, token);
    }
    if (provider2.getCodesByCategory('condition').isEmpty) {
      await provider2.getCodes(
        locale,
        token,
        CodeParams(category: 'condition', active: null),
      );
    }

    int? selectedMedication;
    CodeModel? selectedCode;
    bool isSubmitting = false;
    String? localErrorMessage;

    if (!context.mounted) return;
    final List<String> severities = ['low', 'moderate', 'high'];
    String selectedSeverity = severities.first;

    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final medicationProvider = context.watch<MedicationViewmodel>();
            final medications = medicationProvider.mediactionsList;
            final isMedicationsLoading = medicationProvider.isLoadingList;
            final medicationsError = medicationProvider.getListErrorMessage;

            final codeProvider = context.watch<CodeViewmodel>();
            final codes = codeProvider.getCodesByCategory('condition');
            final isCodesLoading = codeProvider.isLoading;
            final codesError = codeProvider.errorMessage;

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
                width: 600,
                padding: const EdgeInsets.all(28),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interactableType == 'code'
                            ? 'add condition interaction'
                            : 'add medication interaction',
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

                      Text(
                        interactableType == 'code'
                            ? 'Select Condition'
                            : 'Select Medications',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      if (isMedicationsLoading && medications.isEmpty)
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
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                S().loading_nurses,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (medicationsError != null && medications.isEmpty)
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
                                  medicationsError,
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
                                  medicationProvider.getMedications(
                                    locale,
                                    token,
                                  );
                                },
                                child: Text(S().retry),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        if (interactableType == 'medication') ...[
                          DropdownSearch<MedicationModel>(
                            items: (filter, loadProps) => medications,
                            compareFn: (a, b) => a.id == b.id,
                            itemAsString: (item) => item.code.display,
                            selectedItem: selectedMedication == null
                                ? null
                                : medications
                                      .where((e) => e.id == selectedMedication)
                                      .isNotEmpty
                                ? medications.firstWhere(
                                    (e) => e.id == selectedMedication,
                                  )
                                : null,
                            onSelected: (value) {
                              if (value != null) {
                                setState(() => selectedMedication = value.id);
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
                        ] else ...[
                          if (isCodesLoading && codes.isEmpty)
                            Container(
                              height: 52,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
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
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    S().loading_nurses,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface.withAlpha(
                                        (0.5 * 255).toInt(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (codesError != null && codes.isEmpty)
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
                                      codesError,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
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
                                      codeProvider.getCodes(
                                        locale,
                                        token,
                                        CodeParams(
                                          category: 'condition',
                                          active: null,
                                        ),
                                      );
                                    },
                                    child: Text(S().retry),
                                  ),
                                ],
                              ),
                            )
                          else
                            DropdownSearch<CodeModel>(
                              items: (filter, loadProps) => codes,
                              compareFn: (a, b) => a.id == b.id,
                              itemAsString: (item) => item.display,
                              selectedItem: selectedCode,
                              onSelected: (value) {
                                setState(() => selectedCode = value);
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
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          item.display,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
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
                        ],
                      ],
                      SizedBox(height: 15.h),
                      Text(
                        'Select severity',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedSeverity,
                        decoration: StyleWidget.buildDropdownInputDecoration(
                          context,
                        ),
                        items: severities.map((severity) {
                          return DropdownMenuItem<String>(
                            value: severity,
                            child: Text(
                              severity,
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedSeverity = value;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 14.h),
                      CustomTextField(
                        controller: descController,
                        icon: null,
                        text: S().description,
                        hint: 'Enter Description ...',
                        isValidation: false,
                        isPhone: false,
                        multiLine: true,
                      ),
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
                                    final viewmodel = context
                                        .read<InteractionViewmodel>();
                                    if (selectedMedication == null &&
                                        interactableType == 'medication') {
                                      setState(() {
                                        localErrorMessage =
                                            'Please Select Medication';
                                      });
                                      return;
                                    } else if (selectedCode == null &&
                                        interactableType == 'code') {
                                      setState(() {
                                        localErrorMessage =
                                            'Please Select Condition';
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

                                    AddInteractionParams params =
                                        AddInteractionParams(
                                          interactableId:
                                              interactableType == 'medication'
                                              ? selectedMedication != null
                                                    ? selectedMedication!
                                                    : 0
                                              : selectedCode != null
                                              ? selectedCode!.id
                                              : 0,
                                          severity: selectedSeverity,
                                          description: descController.text,
                                          medicationId: medicationId,
                                          interactableType: interactableType,
                                        );
                                    final success = await viewmodel
                                        .addInteraction(params, locale, token);

                                    if (!context.mounted) return;

                                    if (success) {
                                      Navigator.pop(context);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            AppSnackbar.show(
                                              context,
                                              message:
                                                  'Interaction Added Successfully',
                                              type: SnackbarType.success,
                                            );
                                          });
                                    } else {
                                      setState(() {
                                        isSubmitting = false;
                                        localErrorMessage =
                                            viewmodel.addErrorMessage ??
                                            S().unknown_error;
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
                                    S().add,
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

  static void showDeleteDialog(BuildContext context, int interactionId) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<InteractionViewmodel>(
          builder: (context, provider, child) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                'delete interaction',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'This interaction will be removed',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: provider.deleteisLoading
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
                      onPressed: provider.deleteisLoading
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

                              final success = await provider.deleteInteraction(
                                interactionId,
                                locale,
                                token,
                              );

                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }

                              if (success) {
                                AppSnackbar.show(
                                  context,
                                  message: S().nurse_removed_successfully,
                                  type: SnackbarType.success,
                                );
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      provider.deleteErrorMessage ??
                                      S().unknown_error,
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
                      child: provider.deleteisLoading
                          ? const SpinKitThreeInOut(
                              color: Colors.white,
                              size: 20,
                            )
                          : Text(
                              S().remove,
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
