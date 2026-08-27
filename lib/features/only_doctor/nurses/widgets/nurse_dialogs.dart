import 'package:dropdown_search/dropdown_search.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/nurses/viewmodels/encounter_nurses_viewmodel.dart';
import 'package:marbella/features/shared/profile/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class NurseDialogs {
  static Future<void> showAddNurseDialog(
    BuildContext context, {
    required int encounterId,
    required Future<void> Function()? onSuccess,
  }) async {
    final provider = context.read<EncounterNursesViewmodel>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (provider.allNurses.isEmpty) {
      final locale = Localizations.localeOf(context).languageCode;
      final token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      await provider.getAllNurses(locale, token);
    }

    EmployeeModel? selectedNurse;
    bool isSubmitting = false;
    String? localErrorMessage;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final nursesProvider = context.watch<EncounterNursesViewmodel>();
            final nurses = nursesProvider.allNurses;
            final isNursesLoading = nursesProvider.isLoadingAllNurses;
            final nursesError = nursesProvider.allNursesErrorMessage;

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
                        S().add_nurse,
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
                        S().select_nurse,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      if (isNursesLoading && nurses.isEmpty)
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
                      else if (nursesError != null && nurses.isEmpty)
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
                                  nursesError,
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
                                  nursesProvider.getAllNurses(locale, token);
                                },
                                child: Text(S().retry),
                              ),
                            ],
                          ),
                        )
                      else
                        DropdownSearch<EmployeeModel>(
                          items: (filter, loadProps) => nurses,
                          compareFn: (a, b) => a.id == b.id,
                          itemAsString: (item) =>
                              '${item.firstName} ${item.lastName}',
                          selectedItem: selectedNurse,
                          onSelected: (value) {
                            setState(() => selectedNurse = value);
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
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    AppAvatar(
                                      size: 36,
                                      imageUrl: item.image?.url,
                                      initials:
                                          '${item.firstName.isNotEmpty ? item.firstName[0] : ''}${item.lastName.isNotEmpty ? item.lastName[0] : ''}'
                                              .toUpperCase(),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.firstName} ${item.lastName}',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          if (item.specialization
                                              .trim()
                                              .isNotEmpty)
                                            Text(
                                              item.specialization,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: colorScheme.primary,
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
                                    if (selectedNurse == null) {
                                      setState(() {
                                        localErrorMessage =
                                            S().please_select_nurse;
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

                                    final success = await nursesProvider
                                        .addNurseToEncounter(
                                          locale,
                                          token,
                                          encounterId,
                                          selectedNurse!.id,
                                        );

                                    if (!context.mounted) return;

                                    if (success) {
                                      Navigator.pop(context);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            AppSnackbar.show(
                                              context,
                                              message:
                                                  S().nurse_added_successfully,
                                              type: SnackbarType.success,
                                            );
                                          });
                                      onSuccess?.call();
                                    } else {
                                      setState(() {
                                        isSubmitting = false;
                                        localErrorMessage =
                                            nursesProvider.addErrorMessage ??
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

  static void showDeleteDialog(
    BuildContext context,
    int encounterId,
    int nurseId, {
    required Future<void> Function()? onSuccess,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<EncounterNursesViewmodel>(
          builder: (context, provider, child) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                S().remove_nurse,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                S().remove_nurse_warning,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onPressed: provider.deleteIsLoading
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
                      onPressed: provider.deleteIsLoading
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

                              final success = await provider
                                  .deleteEncounterNurse(
                                    locale,
                                    token,
                                    encounterId,
                                    nurseId,
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
                                onSuccess?.call();
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
                      child: provider.deleteIsLoading
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
