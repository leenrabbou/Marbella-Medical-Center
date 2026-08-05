import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/custom_button_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/theme_viewmodel.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/shared/password/views/change_password_view.dart';
import 'package:marbella/features/shared/auth/views/login_view.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});
  @override
  State<SettingsView> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeViewmodel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final language = context.watch<LocalizationViewmodel>();
    Locale? currentLocale = language.language;
    return Scaffold(
      appBar: AppBar(title: Text(S().settings)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingContainer(
                  height: 60.h,
                  child: ListTile(
                    leading: Icon(
                      Icons.language,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    title: Text(
                      S().language,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    ),
                    trailing: DropdownButton<Locale>(
                      value: currentLocale,
                      underline: const SizedBox(),
                      onChanged: (Locale? locale) {
                        language.setLanguage(locale);
                      },
                      items: [
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(
                            S().english,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(),
                          ),
                        ),
                        DropdownMenuItem(
                          value: const Locale('ar'),
                          child: Text(
                            S().arabic,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _buildSettingContainer(
                  height: 60.h,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dark_mode,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              S().dark_theme,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(),
                            ),
                          ],
                        ),
                        FlutterSwitch(
                          width: 35,
                          height: 20,
                          toggleSize: 15,
                          activeColor: colorScheme.primary,
                          value: themeProvider.isDark,
                          onToggle: (value) => themeProvider.toggleTheme(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _buildSettingContainer(
                  height: 120.h,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.palette,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              S().app_theme_color,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 40.h,
                          child: Center(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: Constant.listColors.length,
                              itemBuilder: (context, index) {
                                final color = Constant.listColors[index];
                                final isSelected =
                                    themeProvider.selectedColor == color;
                                return GestureDetector(
                                  onTap: () =>
                                      themeProvider.updatePrimaryColor(color),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    width: isSelected ? 30 : 25,
                                    height: isSelected ? 30 : 25,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : Colors.transparent,
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: color.withAlpha(
                                              (0.3 * 255).toInt(),
                                            ),
                                            blurRadius: 8,
                                          ),
                                      ],
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          )
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _buildSettingContainer(
                  height: 120.h,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.format_size,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              S().text_size_scale,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Aa",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: colorScheme.onSurface,
                                        ),
                                  ),
                                  Text(
                                    "Aa",
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          color: colorScheme.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 2.0,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14,
                                ),
                              ),
                              child: Slider(
                                value: themeProvider.fontSizeScale,
                                min: 0.8,
                                max: 1.4,
                                divisions: 6,
                                label:
                                    "${(themeProvider.fontSizeScale * 100).toInt()}%",
                                onChanged: (value) =>
                                    themeProvider.updateFontSize(value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _buildSettingContainer(
                  height: 60.h,
                  child: ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    title: Text(
                      S().change_password,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colorScheme.onSurface.withAlpha(
                        (0.4 * 255).toInt(),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordView(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                _buildSettingContainer(
                  height: 60.h,
                  child: GestureDetector(
                    onTap: () {
                      showLogoutConfirmationDialog(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red, size: 20),
                      title: Text(
                        S().log_out,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingContainer({
    required Widget child,
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: StyleWidget.cardDecoration(context),
      child: child,
    );
  }
}

Future<void> showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      ColorScheme colorScheme = Theme.of(dialogContext).colorScheme;
      return Consumer<AuthViewmodel>(
        builder: (context, authProvider, child) {
          return AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              S.of(context).logout_confirmation,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: DeviceInfo.width(context) * 0.3,
              child: Text(
                S.of(context).logout_confirmation_msg,
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
                    onPressed: authProvider.isLoadingLogOut
                        ? () {}
                        : () {
                            Navigator.pop(context);
                          },
                    height: 40,
                    width: 140,
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  CustomButtonWidget(
                    onPressed: authProvider.isLoadingLogOut
                        ? () {}
                        : () async {
                            final localizationViewModel = context
                                .read<LocalizationViewmodel>();
                            final localeCode =
                                localizationViewModel.language?.languageCode ??
                                'en';

                            await authProvider.logout(localeCode);

                            if (!context.mounted) return;

                            if (authProvider.logoutSuccessfully == true) {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                                (route) => false,
                              );
                            } else {
                              if (authProvider.errorMessageLogOut != null) {
                                AppSnackbar.show(
                                  context,
                                  message: authProvider.errorMessageLogOut!,
                                  type: SnackbarType.error,
                                );
                              }
                            }
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
                    child: authProvider.isLoadingLogOut
                        ? const SpinKitThreeInOut(color: Colors.white, size: 20)
                        : Text(
                            S().yes_logout,
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
}
