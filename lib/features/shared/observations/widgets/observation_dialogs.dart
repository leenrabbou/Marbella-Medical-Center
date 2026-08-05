import 'package:dropdown_search/dropdown_search.dart';
import 'package:marbella/app/app_role.dart';
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
import 'package:marbella/features/shared/observations/models/observation_model.dart';
import 'package:marbella/features/shared/observations/viewmodels/observation_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ObservationDialogs {
  Future<CodeModel?> showAddCodeDialog(BuildContext context, String category) {
    final formKey = GlobalKey<FormState>();
    late String locale;
    String? token;

    String selectedSystem = "http://loinc.org";

    final codeController = TextEditingController();
    final displayController = TextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String? localMessage;
    bool isSuccess = false;

    return showDialog<CodeModel>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final codeProvider = context.read<CodeViewmodel>();
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
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S().add_code,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (localMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: (isSuccess ? Colors.green : Colors.red)
                                  .withAlpha((0.1 * 255).toInt()),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (isSuccess ? Colors.green : Colors.red)
                                    .withAlpha((0.3 * 255).toInt()),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSuccess
                                      ? Icons.check_circle_outline
                                      : Icons.error_outline,
                                  color: isSuccess ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    localMessage!,
                                    style: TextStyle(
                                      color: isSuccess
                                          ? Colors.green
                                          : Colors.red,
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
                          S().system,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<String>(
                          initialValue: selectedSystem,
                          decoration: StyleWidget.buildDropdownInputDecoration(
                            context,
                          ),
                          items: Constant.systemOptions
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedSystem = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          icon: Icons.code,
                          hint: S().enter_code,
                          text: S().code,
                          controller: codeController,
                          isPassword: false,
                          isPhone: false,
                          isValidation: true,
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          icon: Icons.abc,
                          hint: S().enter_display,
                          text: S().display,
                          controller: displayController,
                          isPassword: false,
                          isPhone: false,
                          isValidation: true,
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButtonWidget(
                              onPressed: () => Navigator.pop(context),
                              height: 40,
                              width: 120,
                              left: 40,
                              right: 40,
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
                              onPressed: codeProvider.isLoadingAdd
                                  ? () {}
                                  : () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }
                                      locale = Localizations.localeOf(
                                        context,
                                      ).languageCode;

                                      token =
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
                                      setState(() => localMessage = null);

                                      AddCodeParams params = AddCodeParams(
                                        system: selectedSystem,
                                        code: codeController.text,
                                        category: category,
                                        display: displayController.text,
                                      );
                                      final newCode = await codeProvider
                                          .addCode(params, locale, token);

                                      if (codeProvider.addSuccessfully &&
                                          newCode != null) {
                                        setState(() {
                                          isSuccess = true;
                                          localMessage =
                                              S().code_created_success;
                                        });

                                        await Future.delayed(
                                          const Duration(milliseconds: 900),
                                        );

                                        if (context.mounted) {
                                          Navigator.pop(context, newCode);
                                        }
                                      } else {
                                        setState(() {
                                          isSuccess = false;
                                          localMessage =
                                              codeProvider.addErrorMessage ??
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
                              child: codeProvider.isLoadingAdd
                                  ? SpinKitThreeInOut(
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Text(
                                      S().save,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
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

  Future<void> showEditObservationDialog(
    BuildContext context,
    ObservationModel? observation,
    int encounterId,
  ) async {
    final observationProvider = context.read<ObservationViewmodel>();
    final isEditMode = observation != null;

    final valueController = TextEditingController(
      text: observation?.value ?? '',
    );
    final unitController = TextEditingController(text: observation?.unit ?? '');
    final noteController = TextEditingController(text: observation?.note ?? '');

    late String locale;
    String? token;

    DateTime? effectiveDate = observation != null
        ? DateTime.tryParse(observation.effectiveDatetime)
        : DateTime.now();

    DateTime? issuedDate = observation?.issuedAt != null
        ? DateTime.tryParse(observation!.issuedAt!)
        : DateTime.now();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int? selectedCode = observation?.code.id;
    String selectedStatus =
        observation?.status ?? S().observation_status_registered;

    bool isSubmitting = false;
    String? localErrorMessage;

    final statuses = [
      S().observation_status_registered,
      S().observation_status_preliminary,
      S().observation_status_final,
      S().observation_status_amended,
      S().cancelled,
    ];
    final provider = context.read<CodeViewmodel>();
    if (provider.getCodesByCategory('observation').isEmpty &&
        !provider.isLoading) {
      final locale = Localizations.localeOf(context).languageCode;
      final token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      context.read<CodeViewmodel>().getCodes(
        locale,
        token,
        CodeParams(active: 1, category: 'observation'),
      );
    }
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final codesProvider = context.watch<CodeViewmodel>();
            final codes = codesProvider.getCodesByCategory('observation');
            final isCodesLoading = codesProvider.isLoading;
            final codesError = codesProvider.errorMessage;
            final role = context.read<AppRole>();
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
                        isEditMode ? S().edit_observation : S().add_observation,
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
                                  S().observation_type,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
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
                                            size: 15,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          S().loading_observations,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: colorScheme.onSurface
                                                    .withAlpha(
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
                                            final locale =
                                                Localizations.localeOf(
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
                                            context
                                                .read<CodeViewmodel>()
                                                .getCodes(
                                                  locale,
                                                  token,
                                                  CodeParams(
                                                    active: 1,
                                                    category: 'observation',
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
                                    selectedItem: selectedCode == null
                                        ? null
                                        : codes
                                              .where(
                                                (e) => e.id == selectedCode,
                                              )
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
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                            textColor: colorScheme.primary,
                                            elevation: 0,
                                            child: Text(
                                              S().cancel,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (role == AppRole.doctor) ...[
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              onPressed: () async {
                                final newCode = await ObservationDialogs()
                                    .showAddCodeDialog(context, 'observation');
                                if (newCode != null) {
                                  setState(() => selectedCode = newCode.id);
                                }
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
                        ],
                      ),
                      const SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S().status,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: selectedStatus,
                            decoration:
                                StyleWidget.buildDropdownInputDecoration(
                                  context,
                                ),
                            items: statuses
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      Constant.statusLabel(e),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => selectedStatus = v);
                            },
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
                            initialDate: effectiveDate ?? DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => effectiveDate = date);
                          }
                        },
                        child: IgnorePointer(
                          child: CustomTextField(
                            icon: Icons.calendar_today_rounded,
                            text: S().effective_date,
                            isPhone: false,
                            hint: effectiveDate == null
                                ? S().choose_date
                                : "${effectiveDate!.day}-${effectiveDate!.month}-${effectiveDate!.year}",
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
                            initialDate: issuedDate ?? DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => issuedDate = date);
                          }
                        },
                        child: IgnorePointer(
                          child: CustomTextField(
                            icon: Icons.event_available_outlined,
                            text: S().issued_at,
                            isPhone: false,
                            hint: issuedDate == null
                                ? S().choose_date
                                : "${issuedDate!.day}-${issuedDate!.month}-${issuedDate!.year}",
                            isValidation: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              controller: valueController,
                              icon: Icons.analytics_outlined,
                              text: S().value,
                              hint: S().enter_value,
                              isPhone: false,
                              isValidation: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: CustomTextField(
                              controller: unitController,
                              icon: Icons.scale_outlined,
                              text: S().unit,
                              hint: S().enter_unit,
                              isPhone: false,
                              isValidation: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
                            color: Theme.of(context).colorScheme.surface,
                            textColor: colorScheme.primary,
                            elevation: 0,
                            child: Text(
                              S().cancel,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          CustomButtonWidget(
                            onPressed: isSubmitting
                                ? () {}
                                : () async {
                                    if (selectedCode == null) {
                                      setState(() {
                                        localErrorMessage =
                                            S().select_observation_type;
                                      });
                                      return;
                                    }

                                    setState(() {
                                      isSubmitting = true;
                                      localErrorMessage = null;
                                    });

                                    locale = Localizations.localeOf(
                                      context,
                                    ).languageCode;
                                    token =
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
                                      final params = UpdateObservationParams(
                                        codeId: selectedCode!,
                                        status: selectedStatus,
                                        effectiveDatetime: effectiveDate
                                            .toString(),
                                        issuedAt: issuedDate?.toString(),
                                        note: noteController.text,
                                        unit: unitController.text,
                                        value: valueController.text,
                                      );
                                      success = await observationProvider
                                          .updateObservation(
                                            params,
                                            observation.id,
                                            locale,
                                            token,
                                          );
                                    } else {
                                      final params = AddObservationParams(
                                        encounterId: encounterId,
                                        codeId: selectedCode!,
                                        status: selectedStatus,
                                        effectiveDatetime: effectiveDate
                                            .toString(),
                                        issuedAt: issuedDate?.toString(),
                                        note: noteController.text,
                                        unit: unitController.text,
                                        value: valueController.text,
                                      );
                                      success = await observationProvider
                                          .addObservation(
                                            params,
                                            locale,
                                            token,
                                          );
                                    }

                                    if (!context.mounted) return;

                                    if (success) {
                                      Navigator.pop(context);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            AppSnackbar.show(
                                              context,
                                              message: isEditMode
                                                  ? S().observation_updated
                                                  : S().observation_added,
                                              type: SnackbarType.success,
                                            );
                                          });
                                    } else {
                                      setState(() {
                                        isSubmitting = false;
                                        localErrorMessage =
                                            (isEditMode
                                                ? observationProvider
                                                      .updateErrorMessage
                                                : observationProvider
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
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
            );
          },
        );
      },
    );
  }
}
