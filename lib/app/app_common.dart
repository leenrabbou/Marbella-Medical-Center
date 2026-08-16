import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/core/databases/cache/secure_storage_service.dart';
import 'package:marbella/core/providers/app_providers.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_token_provider.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/auth/views/login_view.dart';
import 'package:marbella/features/shared/notifications/service/notifications_service.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/theme_viewmodel.dart';
import 'package:marbella/features/shared/settings/views/splash_view.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'app_role.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void runFamilyMedicalApp(AppRole role) async {
  WidgetsFlutterBinding.ensureInitialized();
  final cache = CacheService();
  await cache.init();
  final dataConnectionChecker = DataConnectionChecker();
  final networkInfo = NetworkInfoImpl(dataConnectionChecker);
  final secureStorage = SecureStorageService.instance;
  final tokenProvider = SecureStorageTokenProvider(secureStorage);

  final ApiServices apiService = ApiServices(
    dio: Dio(),
    onUnauthorized: () {
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        ctx.read<AuthViewmodel>().forceLogout();
      }
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginView()),
        (route) => false,
      );
    },
    tokenProvider: tokenProvider,
  );
  await NotificationService(apiService: apiService).initNotification();
  runApp(
    MultiProvider(
      providers: appProviders(
        apiService: apiService,
        networkInfo: networkInfo,
        cache: cache,
        secureStorage: secureStorage,
        role: role,
      ),
      child: FamilyMedicalApp(role: role),
    ),
  );
}

class FamilyMedicalApp extends StatelessWidget {
  final AppRole role;
  const FamilyMedicalApp({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeViewmodel>(context);
    final languageProvider = Provider.of<LocalizationViewmodel>(context);
    return ScreenUtilInit(
      designSize: const Size(1280, 768),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          locale: languageProvider.language,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: SplashView(),
        );
      },
    );
  }
}
