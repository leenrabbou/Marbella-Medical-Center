import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:mocktail/mocktail.dart';
import '../unit_tests/app_mocks.dart';

void main() {
  late MockApiServices mockApi;

  setUp(() {
    mockApi = MockApiServices();
  });

  group('Integration - Add & Retrieve Medical Notes Flow', () {
    const patientId = '4';
    const notePayload = {
      'patient_id': patientId,
      'notes': 'Prescribed Antacids and resting.',
    };

    test('Add medical note and verify its retrieval', () async {
      when(() => mockApi.post('notes', data: notePayload)).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 201,
          data: {
            'status': 1,
            'message': 'Medical note added successfully',
            'data': {'id': '1', ...notePayload},
          },
        ),
      );

      when(() => mockApi.get('patients/$patientId/notes')).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          data: {
            'status': 1,
            'data': [
              {'id': '1', ...notePayload},
            ],
          },
        ),
      );

      final postResponse = await mockApi.post('notes', data: notePayload);
      expect(postResponse.statusCode, 201);

      final getResponse = await mockApi.get('patients/$patientId/notes');

      expect(getResponse.statusCode, 200);
      final List notes = getResponse.data['data'];
      expect(
        notes.any((n) => n['notes'] == 'Prescribed Antacids and resting.'),
        isTrue,
      );
    });
  });
}
