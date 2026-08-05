import 'package:dropdown_search/dropdown_search.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/appointments/models/service_model.dart';
import 'package:marbella/features/shared/encounter_services/models/encounter_service_model.dart';
import 'package:marbella/features/shared/encounter_services/viewmodel/encounter_service_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class EncounterServiceDialogs {
  static Future<void> showAddEncounterServiceDialog(
    BuildContext context, {
    required int encounterId,
  }) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int? selectedServiceId;
    bool isSubmitting = false;
    String? localErrorMessage;
    final serviceProvider = context.read<EncounterServiceViewmodel>();
    if (serviceProvider.allServicesList.isEmpty &&
        !serviceProvider.isLoadingAllServices) {
      final locale = Localizations.localeOf(context).languageCode;
      final token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      serviceProvider.getAllServicesList(locale, token);
    }
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final serviceProvider = context.watch<EncounterServiceViewmodel>();
            final services = serviceProvider.allServicesList;
            final isServicesLoading = serviceProvider.isLoadingAllServices;
            final serviceError = serviceProvider.allServicesErrorMessage;
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
                        S().add_service,
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
                        S().service,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      if (isServicesLoading && services.isEmpty)
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
                                S().loading_services,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (serviceError != null && services.isEmpty)
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
                                  serviceError,
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
                                  serviceProvider.getAllServicesList(
                                    locale,
                                    token!,
                                  );
                                },
                                child: Text(S().retry),
                              ),
                            ],
                          ),
                        )
                      else
                        DropdownSearch<ServiceModel>(
                          items: (filter, loadProps) => services,
                          compareFn: (a, b) => a.id == b.id,
                          itemAsString: (item) => item.name,
                          selectedItem: selectedServiceId == null
                              ? null
                              : services
                                    .where((e) => e.id == selectedServiceId)
                                    .isNotEmpty
                              ? services.firstWhere(
                                  (e) => e.id == selectedServiceId,
                                )
                              : null,
                          onSelected: (value) {
                            if (value != null) {
                              setState(() => selectedServiceId = value.id);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.medical_services_outlined,
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
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              Text(
                                                '${item.price.toInt()}',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withAlpha(
                                                            (0.5 * 255).toInt(),
                                                          ),
                                                    ),
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
                                    if (selectedServiceId == null) {
                                      setState(() {
                                        localErrorMessage =
                                            S().please_select_service;
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

                                    final params = AddEncounterServiceParams(
                                      encounterId: encounterId,
                                      serviceId: selectedServiceId,
                                    );

                                    final success = await serviceProvider
                                        .addEncounterService(
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
                                              message: S()
                                                  .service_added_successfully,
                                              type: SnackbarType.success,
                                            );
                                          });
                                    } else {
                                      setState(() {
                                        isSubmitting = false;
                                        localErrorMessage =
                                            serviceProvider.addErrorMessage ??
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

  static Future<void> showEditEncounterServiceDialog(
    BuildContext context,
    EncounterServiceModel encounterService,
  ) async {
    final encounterServiceProvider = context.read<EncounterServiceViewmodel>();

    final noteController = TextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String selectedStatus = encounterService.status;
    bool isSelectedStatus = false;
    final statuses = ["pending", "completed", "canceled"];

    bool isSubmitting = false;
    String? localErrorMessage;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        S().update_service_status,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        encounterService.service.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(
                            (0.5 * 255).toInt(),
                          ),
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
                        S().status,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        decoration: StyleWidget.buildDropdownInputDecoration(
                          context,
                        ),
                        items: statuses
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
                          if (v != null) setState(() => selectedStatus = v);
                          isSelectedStatus = true;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: noteController,
                        icon: Icons.sticky_note_2_outlined,
                        text: S().note,
                        hint: S().optional_note_hint,
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

                                    final params = UpdateEncounterServiceParams(
                                      status: isSelectedStatus
                                          ? selectedStatus
                                          : null,
                                      note: noteController.text,
                                    );

                                    final success =
                                        await encounterServiceProvider
                                            .updateEncounterService(
                                              params,
                                              encounterService.id,
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
                                              message: S()
                                                  .service_updated_successfully,
                                              type: SnackbarType.success,
                                            );
                                          });
                                    } else {
                                      setState(() {
                                        isSubmitting = false;
                                        localErrorMessage =
                                            encounterServiceProvider
                                                .updateErrorMessage ??
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

  static void showDeleteEncounterServiceDialog(
    BuildContext context,
    EncounterServiceModel encounterService,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<EncounterServiceViewmodel>(
          builder: (context, encounterServiceProvider, child) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                S().delete_service,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().service_delete_warning,
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
                      onPressed: encounterServiceProvider.deleteisLoading
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
                      onPressed: encounterServiceProvider.deleteisLoading
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

                              bool success = await encounterServiceProvider
                                  .deleteEncounterService(
                                    encounterService.id,
                                    locale,
                                    token,
                                  );

                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }

                              if (success) {
                                AppSnackbar.show(
                                  context,
                                  message: S().service_deleted_successfully,
                                  type: SnackbarType.success,
                                );
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      encounterServiceProvider
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
                      child: encounterServiceProvider.deleteisLoading
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
