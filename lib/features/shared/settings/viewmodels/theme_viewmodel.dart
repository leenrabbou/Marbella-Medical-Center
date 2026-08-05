import 'package:flutter/material.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/themes/dark_theme.dart';
import 'package:marbella/core/themes/light_theme.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';

class ThemeViewmodel with ChangeNotifier {
  bool _isDark = false;
  double _fontSizeScale = 1.0;
  Color _selectedColor = const Color(0xff089bab);
  bool get isDark => _isDark;
  double get fontSizeScale => _fontSizeScale;
  Color get selectedColor => _selectedColor;
  ThemeViewmodel() {
    _loadThemeFromPrefs();
  }
  ThemeData get currentTheme {
    final baseTheme = _isDark
        ? getDarkMode(_selectedColor)
        : getLightMode(_selectedColor);
    return baseTheme.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: _scaleTextTheme(baseTheme.textTheme),
    );
  }

  TextTheme _scaleTextTheme(TextTheme base) {
    TextStyle? scale(TextStyle? style) {
      if (style == null || style.fontSize == null) return style;
      return style.copyWith(fontSize: style.fontSize! * _fontSizeScale);
    }

    return base.copyWith(
      displayLarge: scale(base.displayLarge),
      displayMedium: scale(base.displayMedium),
      displaySmall: scale(base.displaySmall),
      headlineLarge: scale(base.headlineLarge),
      headlineMedium: scale(base.headlineMedium),
      headlineSmall: scale(base.headlineSmall),
      titleLarge: scale(base.titleLarge),
      titleMedium: scale(base.titleMedium),
      titleSmall: scale(base.titleSmall),
      bodyLarge: scale(base.bodyLarge),
      bodyMedium: scale(base.bodyMedium),
      bodySmall: scale(base.bodySmall),
      labelLarge: scale(base.labelLarge),
      labelMedium: scale(base.labelMedium),
      labelSmall: scale(base.labelSmall),
    );
  }

  void toggleTheme() {
    _isDark = !_isDark;
    saveData(CacheKeys.isDarkTheme, _isDark);
    notifyListeners();
  }

  void updateFontSize(double scale) {
    _fontSizeScale = scale;
    saveData(CacheKeys.fontSize, _fontSizeScale);
    notifyListeners();
  }

  void updatePrimaryColor(Color newColor) {
    _selectedColor = newColor;
    saveData(CacheKeys.colorTheme, newColor.toARGB32());
    notifyListeners();
  }

  void saveData(String key, dynamic data) {
    CacheService().saveData(key: key, value: data);
  }

  void _loadThemeFromPrefs() async {
    _isDark = await CacheService().getData(key: CacheKeys.isDarkTheme) ?? false;
    _fontSizeScale =
        await CacheService().getData(key: CacheKeys.fontSize) ?? 1.0;
    final colorValue = await CacheService().getData(key: CacheKeys.colorTheme);
    _selectedColor = colorValue != null
        ? Color(colorValue)
        : Constant.listColors.first;
    notifyListeners();
  }
}
