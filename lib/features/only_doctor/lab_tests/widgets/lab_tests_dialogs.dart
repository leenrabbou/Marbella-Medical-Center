import 'package:dropdown_search/dropdown_search.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_test_model.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/medical_test_model.dart';
import 'package:marbella/features/only_doctor/lab_tests/viewmodel/lab_test_viewmodel.dart';
import 'package:marbella/features/only_doctor/lab_tests/viewmodel/medical_test_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LabTestDialogs {
  static Future<void> showAddLabTestDialog(
    BuildContext context, {
    required int patientId,
  }) async {
    final labTestProvider = context.read<LabTestViewmodel>();
    final medicalTestProvider = context.read<MedicalTestViewmodel>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (medicalTestProvider.medicalTestsList.isEmpty &&
        !medicalTestProvider.isLoadingList) {
      final locale = Localizations.localeOf(context).languageCode;
      final token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      medicalTestProvider.getMedicalTests(locale, token);
    }

    int? selectedMedicalTestId;
    bool isSubmitting = false;
    String? localErrorMessage;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final medTestProvider = context.watch<MedicalTestViewmodel>();
            final medicalTests = medTestProvider.medicalTestsList;
            final isLoading = medTestProvider.isLoadingList;

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
                        S().add_lab_test,
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
                        S().medical_test,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      if (isLoading && medicalTests.isEmpty)
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
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                S().loading,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        DropdownSearch<MedicalTestModel>(
                          items: (filter, loadProps) => medicalTests,
                          compareFn: (a, b) => a.id == b.id,
                          itemAsString: (item) => item.name,
                          selectedItem: selectedMedicalTestId == null
                              ? null
                              : medicalTests
                                    .where((e) => e.id == selectedMedicalTestId)
                                    .isNotEmpty
                              ? medicalTests.firstWhere(
                                  (e) => e.id == selectedMedicalTestId,
                                )
                              : null,
                          onSelected: (value) {
                            if (value != null) {
                              setState(() => selectedMedicalTestId = value.id);
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
                            itemBuilder: (context, item, isDisabled, isSelected) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.biotech_outlined,
                                      size: 18,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${item.category} • ${item.price}',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withAlpha(
                                                            (0.5 * 255).toInt(),
                                                          ),
                                                    ),
                                              ),
                                              SizedBox(width: 2.w),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 5.h,
                                                ),
                                                child: Text(
                                                  S().syp,
                                                  style: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurface
                                                            .withAlpha(
                                                              (0.5 * 255)
                                                                  .toInt(),
                                                            ),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                                    if (selectedMedicalTestId == null) {
                                      setState(() {
                                        localErrorMessage =
                                            S().select_medical_test;
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

                                    final params = AddPatientLabTestParams(
                                      patientId: patientId,
                                      medicalTestId: selectedMedicalTestId!,
                                    );

                                    final success = await labTestProvider
                                        .addPatientLabTest(
                                          params,
                                          locale,
                                          token,
                                        );

                                    if (!context.mounted) return;

                                    if (success) {
                                      Navigator.pop(context);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            AppSnackbar.show(
                                              context,
                                              message: S().lab_test_added,
                                              type: SnackbarType.success,
                                            );
                                          });
                                    } else {
                                      setState(() {
                                        isSubmitting = false;
                                        localErrorMessage =
                                            labTestProvider.addErrorMessage ??
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

  static void showDeleteLabTestDialog(
    BuildContext context,
    LabTestModel labTest,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<LabTestViewmodel>(
          builder: (context, labTestProvider, child) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                S().cancel_lab_test,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().lab_test_cancel_warning,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    S().are_you_sure_continue,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: labTestProvider.deleteIsLoading
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
                      onPressed: labTestProvider.deleteIsLoading
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

                              final success = await labTestProvider
                                  .deletePatientLabTest(
                                    labTest.id,
                                    locale,
                                    token,
                                  );

                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }

                              if (success) {
                                AppSnackbar.show(
                                  context,
                                  message: S().lab_test_deleted,
                                  type: SnackbarType.success,
                                );
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      labTestProvider.deleteErrorMessage ??
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
                      child: labTestProvider.deleteIsLoading
                          ? const SpinKitThreeInOut(
                              color: Colors.white,
                              size: 20,
                            )
                          : Text(
                              S().cancel,
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
