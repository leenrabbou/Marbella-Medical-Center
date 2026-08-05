import 'dart:io';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/medication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/core/widgets/custom_textfield_widget.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class MedicationDialogs {
  static Future<void> showMedicationDialog(
    BuildContext context,
    MedicationModel? medication,
  ) async {
    final medicationProvider = context.read<MedicationViewmodel>();
    final isEditMode = medication != null;

    final formKey = GlobalKey<FormState>();

    String selectedSystem = Constant.systemOptions.first;
    bool isSystemEdited = false;

    final codeController = TextEditingController();
    final displayController = TextEditingController();
    final descriptionController = TextEditingController();
    final formController = TextEditingController();
    final strengthController = TextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    File? pickedImage;
    String? filePath;
    String? existingImageUrl = medication?.image?.url;

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
                          isEditMode ? S().edit_medication : S().add_medication,
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

                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final picker = ImagePicker();
                              final file = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                              );
                              if (file != null) {
                                setState(() {
                                  pickedImage = File(file.path);
                                  filePath = file.path;
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withAlpha(
                                      (0.08 * 255).toInt(),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: pickedImage != null
                                      ? Image.file(
                                          pickedImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : (existingImageUrl != null &&
                                            existingImageUrl.trim().isNotEmpty)
                                      ? Image.network(
                                          existingImageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.medication_outlined,
                                            color: colorScheme.primary,
                                            size: 32,
                                          ),
                                        )
                                      : Icon(
                                          Icons.medication_outlined,
                                          color: colorScheme.primary,
                                          size: 32,
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colorScheme.surface,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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
                              setState(() {
                                selectedSystem = value;
                                isSystemEdited = true;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          icon: Icons.code,
                          hint: medication == null
                              ? S().enter_code
                              : medication.code.code,
                          text: S().code,
                          controller: codeController,
                          isPassword: false,
                          isPhone: false,
                          isValidation: !isEditMode,
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          icon: Icons.abc,
                          hint: medication == null
                              ? S().enter_display
                              : medication.code.display,
                          text: S().display,
                          controller: displayController,
                          isPassword: false,
                          isPhone: false,
                          isValidation: !isEditMode,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: formController,
                                icon: Icons.medication_liquid_outlined,
                                text: S().form,
                                hint: medication == null
                                    ? S().add_medication_form_hint
                                    : medication.form,
                                isPhone: false,
                                isValidation: !isEditMode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                controller: strengthController,
                                icon: Icons.science_outlined,
                                text: S().strength,
                                hint: medication == null
                                    ? S().add_medication_strength_hint
                                    : medication.strength ??
                                          S().add_medication_strength_hint,
                                isPhone: false,
                                isValidation: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: descriptionController,
                          icon: Icons.description_outlined,
                          text: S().description,
                          hint: medication == null
                              ? S().add_description_hint
                              : medication.description ??
                                    S().add_description_hint,
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
                                      final params = UpdateMedicationParams(
                                        description: descriptionController.text,
                                        form: formController.text,
                                        strength:
                                            strengthController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : strengthController.text,
                                        image: filePath,
                                        system: medication == null
                                            ? selectedSystem
                                            : isSystemEdited
                                            ? selectedSystem
                                            : null,
                                        code: codeController.text,
                                        display: displayController.text,
                                      );

                                      if (isEditMode) {
                                        success = await medicationProvider
                                            .updateMedication(
                                              params,
                                              medication.id,
                                              locale,
                                              token,
                                            );
                                      } else {
                                        success = await medicationProvider
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
                                      } else {
                                        setState(() {
                                          isSubmitting = false;
                                          localErrorMessage =
                                              (isEditMode
                                                  ? medicationProvider
                                                        .updateErrorMessage
                                                  : medicationProvider
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

  static void showDeleteMedicationDialog(
    BuildContext context,
    MedicationModel medication,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<MedicationViewmodel>(
          builder: (context, medicationProvider, child) {
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
                      onPressed: medicationProvider.deleteisLoading
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
                      onPressed: medicationProvider.deleteisLoading
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

                              bool success = await medicationProvider
                                  .deleteMedication(
                                    medication.id,
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
                                      medicationProvider.deleteErrorMessage ??
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
                      child: medicationProvider.deleteisLoading
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
