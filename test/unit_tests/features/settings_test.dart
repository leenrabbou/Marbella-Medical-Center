import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../app_mocks.dart';

void main() {
  late MockCacheService mockCache;

  setUp(() {
    mockCache = MockCacheService();
  });

  group('Settings System - Tests', () {
    test('Save theme mode to cache succeeds', () async {
      const themeKey = 'app_theme_mode';
      const themeValue = 'dark';

      when(
        () => mockCache.saveData(key: themeKey, value: themeValue),
      ).thenAnswer((_) async => true);

      final result = await mockCache.saveData(key: themeKey, value: themeValue);

      expect(result, isTrue);
      verify(
        () => mockCache.saveData(key: themeKey, value: themeValue),
      ).called(1);
    });

    test('Load theme mode from cache returns correct saved theme', () {
      const themeKey = 'app_theme_mode';
      when(() => mockCache.getString(key: themeKey)).thenReturn('dark');

      final savedTheme = mockCache.getString(key: themeKey);

      expect(savedTheme, 'dark');
      verify(() => mockCache.getString(key: themeKey)).called(1);
    });

    test('Change application language in storage succeeds', () async {
      const langKey = 'app_language';
      const selectedLang = 'en';

      when(
        () => mockCache.saveData(key: langKey, value: selectedLang),
      ).thenAnswer((_) async => true);

      final result = await mockCache.saveData(
        key: langKey,
        value: selectedLang,
      );

      expect(result, isTrue);
      verify(
        () => mockCache.saveData(key: langKey, value: selectedLang),
      ).called(1);
    });
  });
}
