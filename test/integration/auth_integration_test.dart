import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/auth/services/auth_service.dart';
import '../unit_tests/app_mocks.dart';

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

  group('Integration - Authentication Flow with Laravel Backend', () {
    final loginParams = LoginParams(
      phoneNumber: '0999999999',
      password: 'Password123!',
    );

    test(
      'Login from Flutter reaches Laravel API and stores user session token',
      () async {
        when(
          () => mockApi.post(EndPoints.login, data: any(named: 'data')),
        ).thenAnswer(
          (_) async => ApiResponse(
            statusCode: 200,
            data: {
              'status': 1,
              'message': 'Logged in successfully',
              'data': {
                'id': 101,
                'name': 'Leen',
                'phone_number': '0999999999',
                'token': 'bearer_token_123456',
                'role': 'doctor',
              },
            },
          ),
        );

        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        final result = await authService.logIn(loginParams, 'en');

        expect(result.isRight(), true);
        result.fold((_) => fail('expected Right, got Left'), (auth) {
          expect(auth.data?.token, 'bearer_token_123456');
          expect(auth.data?.name, 'Leen');
        });
        final captured = verify(
          () => mockSecureStorage.write(
            key: captureAny(named: 'key'),
            value: captureAny(named: 'value'),
          ),
        ).captured;

        expect(captured[0], CacheKeys.userKey);
        expect(captured[1], contains('bearer_token_123456'));
      },
    );

    test(
      'Login with wrong credentials returns an error and never writes to secure storage',
      () async {
        when(
          () => mockApi.post(EndPoints.login, data: any(named: 'data')),
        ).thenAnswer(
          (_) async => ApiResponse(
            statusCode: 401,
            error: ErrorModel(status: 401, errorMessage: 'Invalid credentials'),
          ),
        );

        final result = await authService.logIn(loginParams, 'en');

        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error.status, 401),
          (_) => fail('expected Left, got Right'),
        );

        verifyNever(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        );
      },
    );
  });
}
