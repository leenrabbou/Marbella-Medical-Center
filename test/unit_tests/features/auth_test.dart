import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/auth/services/auth_service.dart';
import '../app_mocks.dart';

void main() {
  late MockApiServices mockApi;
  late MockSecureStorageService mockSecureStorage;
  late AuthService authService;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApi = MockApiServices();
    mockSecureStorage = MockSecureStorageService();
    authService = AuthService(
      apiService: mockApi,
      secureStorage: mockSecureStorage,
    );
  });

  final loginParams = LoginParams(
    phoneNumber: '0999999999',
    password: '123456',
  );

  group('Authentication - logIn', () {
    test('Success (200) => returns Right and caches user data', () async {
      when(() => mockApi.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          data: {
            ApiKey.status: 1,
            ApiKey.message: 'ok',
            ApiKey.data: {
              ApiKey.id: 1,
              ApiKey.name: 'Leen',
              ApiKey.phoneNumber: '0999999999',
              ApiKey.phoneNumberVerifiedAt: null,
              ApiKey.token: 'token',
              ApiKey.role: 'doctor',
            },
          },
        ),
      );
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => true);

      final result = await authService.logIn(loginParams, 'en');

      expect(result.isRight(), true);
      verify(
        () => mockSecureStorage.write(
          key: CacheKeys.userKey,
          value: any(named: 'value'),
        ),
      ).called(1);
    });

    test('Failure (401) => returns Left with error message', () async {
      when(() => mockApi.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 401,
          error: ErrorModel(status: 401, errorMessage: 'Invalid credentials'),
        ),
      );

      final result = await authService.logIn(loginParams, 'en');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.errorMessage, 'Invalid credentials'),
        (success) => fail('Should return Left on failure'),
      );
    });

    test('ServerException thrown => returns Left(errorModel)', () async {
      when(() => mockApi.post(any(), data: any(named: 'data'))).thenThrow(
        ServerException(ErrorModel(status: 500, errorMessage: 'Server down')),
      );

      final result = await authService.logIn(loginParams, 'en');

      expect(result.isLeft(), true);
    });
  });

  group('Authentication - loadCachedUser', () {
    test('Cached data exists => returns Right(UserModel)', () async {
      final cachedUser =
          '{"${ApiKey.id}":1,"${ApiKey.name}":"Leen","${ApiKey.phoneNumber}":"0999999999","${ApiKey.phoneNumberVerifiedAt}":null,"${ApiKey.token}":"tok","${ApiKey.role}":"doctor"}';

      when(
        () => mockSecureStorage.read(key: CacheKeys.userKey),
      ).thenAnswer((_) async => cachedUser);

      final result = await authService.loadCachedUser();

      expect(result.isRight(), true);
    });

    test('No cached data => returns Left', () async {
      when(
        () => mockSecureStorage.read(key: CacheKeys.userKey),
      ).thenAnswer((_) async => null);

      final result = await authService.loadCachedUser();

      expect(result.isLeft(), true);
    });
  });

  group('Authentication - logOut', () {
    test('Clears cache on API error inside finally block', () async {
      when(
        () => mockApi.get(any(), headers: any(named: 'headers')),
      ).thenThrow(Exception('Network error'));
      when(() => mockSecureStorage.deleteAll()).thenAnswer((_) async => true);

      await authService.logOut('en', 'token123');

      verify(() => mockSecureStorage.deleteAll()).called(1);
    });

    test('Success => returns Right(null) and clears cache', () async {
      when(
        () => mockApi.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => null);
      when(() => mockSecureStorage.deleteAll()).thenAnswer((_) async => true);

      final result = await authService.logOut('en', 'token123');

      expect(result.isRight(), true);
      verify(() => mockSecureStorage.deleteAll()).called(1);
    });
  });
}
