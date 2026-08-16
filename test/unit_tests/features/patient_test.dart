import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:mocktail/mocktail.dart';

import '../app_mocks.dart';

void main() {
  late MockApiServices mockApi;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApi = MockApiServices();
  });

  group('Patient Management - Search & Notes', () {
    test('Search patients returns filtered list on success (200)', () async {
      when(
        () =>
            mockApi.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          data: {
            ApiKey.data: [
              {ApiKey.id: 1, ApiKey.name: 'Leen'},
              {ApiKey.id: 2, ApiKey.name: 'rima'},
            ],
          },
        ),
      );

      final response = await mockApi.get(
        '/patients/search',
        queryParameters: {'query': 'Leen'},
      );

      expect(response.statusCode, 200);
      expect(response.data[ApiKey.data], hasLength(2));
      verify(
        () =>
            mockApi.get(any(), queryParameters: any(named: 'queryParameters')),
      ).called(1);
    });

    test('Add medical note succeeds on success (200)', () async {
      when(() => mockApi.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          data: {ApiKey.status: 1, ApiKey.message: 'Note added'},
        ),
      );

      final response = await mockApi.post(
        '/patients/notes',
        data: {'note': 'Mild hypertension'},
      );

      expect(response.statusCode, 200);
      verify(() => mockApi.post(any(), data: any(named: 'data'))).called(1);
    });
  });
}
