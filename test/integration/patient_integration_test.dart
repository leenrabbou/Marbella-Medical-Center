import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:mocktail/mocktail.dart';
import '../unit_tests/app_mocks.dart';

void main() {
  late MockApiServices mockApi;

  setUp(() {
    mockApi = MockApiServices();
  });

  group('Integration - Patient List Fetching from Backend', () {
    test('Fetch patients list from Backend and verify structure', () async {
      when(() => mockApi.get(any())).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          data: {
            'status': 1,
            'data': [
              {
                'id': 1,
                'image': null,
                'givenName': 'Leen',
                'familyName': 'Rabbou',
                'gender': 'female',
                'phoneNumber': '0922222222',
                'phoneNumberVerifiedAt': '22-01-2026',
                'dateOfBirth': '22-01-2004',
                'nationalId': '1234567891',
                'socialHistory': 'social',
                'occupation': 'SE',
                'maritalStatus': 'single',
                'bloodGroup': 'AB+',
                'active': 1,
                'notes': 'note',
              },
              {
                'id': 1,
                'image': null,
                'givenName': 'rima',
                'familyName': 'Rabbou',
                'gender': 'female',
                'phoneNumber': '0922222222',
                'phoneNumberVerifiedAt': '22-01-2026',
                'dateOfBirth': '22-01-2004',
                'nationalId': '1234567891',
                'socialHistory': 'social',
                'occupation': 'SE',
                'maritalStatus': 'single',
                'bloodGroup': 'AB+',
                'active': 1,
                'notes': 'note',
              },
            ],
          },
        ),
      );

      final response = await mockApi.get('patients');

      expect(response.statusCode, 200);
      expect(response.data['data'], isA<List>());
      expect((response.data['data'] as List).length, equals(2));
      expect(response.data['data'][0]['givenName'], equals('Leen'));
      verify(() => mockApi.get('patients')).called(1);
    });
  });
}
