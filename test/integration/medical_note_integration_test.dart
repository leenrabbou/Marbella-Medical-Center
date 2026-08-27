import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/encounters/services/encounter_note_service.dart';
import 'package:mocktail/mocktail.dart';
import '../unit_tests/app_mocks.dart';

void main() {
  late MockApiServices mockApi;
  late EncounterNoteService noteService;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApi = MockApiServices();
    noteService = EncounterNoteService(apiService: mockApi);
  });

  group('Integration - Add & Retrieve Encounter (Medical) Notes Flow', () {
    const encounterId = 7;
    const patientId = 4;

    test(
      'Add encounter note sends multipart form data to the real endpoint',
      () async {
        when(
          () => mockApi.post(
            EndPoints.encounterNote,
            headers: any(named: 'headers'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => ApiResponse(statusCode: 201, data: {}));

        final result = await noteService.addEncounterNote(
          'en',
          'token123',
          AddEncounterNoteParams(
            encounterId: encounterId,
            title: 'Follow-up',
            note: 'Prescribed antacids and resting.',
            durationUnit: 'days',
            durationValue: 7,
          ),
        );

        expect(result.isRight(), true);
        final captured = verify(
          () => mockApi.post(
            EndPoints.encounterNote,
            headers: any(named: 'headers'),
            data: captureAny(named: 'data'),
          ),
        ).captured;

        final sentFormData = captured.single as FormData;
        final sentFields = {
          for (final f in sentFormData.fields) f.key: f.value,
        };
        expect(sentFields['encounter_id'], encounterId.toString());
        expect(sentFields['note'], 'Prescribed antacids and resting.');
      },
    );

    test(
      'Fetch encounter notes for a patient returns the parsed list',
      () async {
        when(
          () => mockApi.get(
            EndPoints.encounterNote,
            headers: any(named: 'headers'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => {
            'status': 1,
            'message': 'Encounter notes fetched successfully',
            'data': [
              {
                'id': 1,
                'patient_id': patientId,
                'encounter_id': encounterId,
                'title': 'Follow-up',
                'note': 'Prescribed antacids and resting.',
                'duration_value': 7,
                'duration_unit': 'days',
                'until_date': null,
              },
            ],
          },
        );

        final result = await noteService.getEncounterNotes(
          'en',
          'token123',
          EncounterNoteParams(
            patientId: patientId,
            encounterId: null,
            status: null,
          ),
        );

        expect(result.isRight(), true);
        result.fold((_) => fail('expected Right, got Left'), (list) {
          expect(
            list.data.any((n) => n.note == 'Prescribed antacids and resting.'),
            isTrue,
          );
        });

        verify(
          () => mockApi.get(
            EndPoints.encounterNote,
            headers: any(named: 'headers'),
            queryParameters: {'filter[patient_id]': patientId.toString()},
          ),
        ).called(1);
      },
    );
  });
}
