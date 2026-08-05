import 'package:flutter/material.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:intl/intl.dart';

class LocalizationViewmodel with ChangeNotifier {
  Locale? _language = const Locale('en');
  Locale? get language => _language;
  LocalizationViewmodel() {
    _loadLocaleFromPrefs();
  }
  void setLanguage(Locale? lang) {
    _language = lang;
    saveData(CacheKeys.localKey, _language?.languageCode);
    notifyListeners();
  }

  void saveData(String key, dynamic data) {
    CacheService cacheService = CacheService();
    cacheService.saveData(key: key, value: data);
  }

  void _loadLocaleFromPrefs() async {
    final localCode = await CacheService().getData(key: CacheKeys.localKey);
    if (localCode != null) {
      _language = Locale(localCode);
    }
    notifyListeners();
  }

  static bool isArabic() {
    return Intl.getCurrentLocale() == 'ar';
  }
}
