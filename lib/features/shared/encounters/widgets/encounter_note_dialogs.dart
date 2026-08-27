import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/shared/encounters/models/encounter_note_model.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_note_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class EncounterNoteDialogs {
  static Future<void> showEncounterNoteDialog(
    BuildContext context,
    EncounterNoteModel? note, {
    required Future<void> Function()? onSuccess,
    int? encounterId,
  }) async {
    final noteProvider = context.read<EncounterNoteViewmodel>();
    final isEditMode = note != null;

    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final noteController = TextEditingController();
    final durationValueController = TextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String selectedDurationUnit = note?.durationUnit ?? 'days';
    bool isDorationSelected = false;
    final durationUnits = ['days', 'weeks', 'months'];

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
                width: 650,
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditMode ? S().edit_note : S().add_notes,
                          style: theme.textTheme.titleMedium?.copyWith(
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

                        CustomTextField(
                          controller: titleController,
                          icon: Icons.title_outlined,
                          text: S().title,
                          hint: isEditMode ? note.title : S().enter_title_hint,
                          isPhone: false,
                          isValidation: !isEditMode,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: noteController,
                          icon: Icons.sticky_note_2_outlined,
                          text: S().note,
                          hint: isEditMode ? note.note : S().enter_note_hint,

                          isValidation: !isEditMode,
                          isPhone: false,
                          multiLine: true,
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
                                    ? note.durationValue == null
                                          ? S().enter_duration_hint
                                          : note.durationValue.toString()
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
                                              e,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          selectedDurationUnit = v;
                                          isDorationSelected = true;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                      final durationValue = int.tryParse(
                                        durationValueController.text,
                                      );

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
                                            UpdateEncounterNoteParams(
                                              title: titleController.text,
                                              note: noteController.text,
                                              durationValue: durationValue,
                                              durationUnit: isDorationSelected
                                                  ? selectedDurationUnit
                                                  : null,
                                            );
                                        success = await noteProvider
                                            .updateEncounterNote(
                                              params,
                                              note.id,
                                              locale,
                                              token,
                                            );
                                      } else {
                                        final params = AddEncounterNoteParams(
                                          encounterId: encounterId!,
                                          title: titleController.text,
                                          note: noteController.text,
                                          durationValue: durationValue,
                                          durationUnit: selectedDurationUnit,
                                        );
                                        success = await noteProvider
                                            .addEncounterNote(
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
                                                    ? S().note_updated_successfully
                                                    : S().note_added_successfully,
                                                type: SnackbarType.success,
                                              );
                                            });
                                        onSuccess?.call();
                                      } else {
                                        setState(() {
                                          isSubmitting = false;
                                          localErrorMessage =
                                              (isEditMode
                                                  ? noteProvider
                                                        .updateErrorMessage
                                                  : noteProvider
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

  static void showDeleteEncounterNoteDialog(
    BuildContext context,
    EncounterNoteModel note, {
    required Future<void> Function()? onSuccess,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<EncounterNoteViewmodel>(
          builder: (context, noteProvider, child) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                S().delete_note,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().note_delete_warning,
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
                      onPressed: noteProvider.deleteisLoading
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
                      onPressed: noteProvider.deleteisLoading
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

                              bool success = await noteProvider
                                  .deleteEncounterNote(note.id, locale, token);

                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }

                              if (success) {
                                AppSnackbar.show(
                                  context,
                                  message: S().note_deleted_successfully,
                                  type: SnackbarType.success,
                                );
                                onSuccess?.call();
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      noteProvider.deleteErrorMessage ??
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
                      child: noteProvider.deleteisLoading
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
