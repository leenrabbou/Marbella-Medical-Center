import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/errors/api_response.dart';
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
          () => mockApi.post(
            any(),
            data: any(named: 'data'),
            headers: any(named: 'headers'),
            queryParameters: any(named: 'queryParameters'),
            isFormData: any(named: 'isFormData'),
          ),
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
        ).thenAnswer((_) async => true);

        final result = await authService.logIn(loginParams, 'en');
        expect(result.isRight(), true);
        verify(
          () => mockApi.post(
            any(),
            data: any(named: 'data'),
            headers: any(named: 'headers'),
            queryParameters: any(named: 'queryParameters'),
            isFormData: any(named: 'isFormData'),
          ),
        ).called(1);
      },
    );
  });
}
