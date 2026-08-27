import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/medications/models/condition_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/models/drug_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/services/interaction_service.dart';
import 'package:mocktail/mocktail.dart';
import '../unit_tests/app_mocks.dart';

void main() {
  late MockApiServices mockApi;
  late InteractionService interactionService;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApi = MockApiServices();
    interactionService = InteractionService(apiService: mockApi);
  });

  group('Medication & Condition Interaction Conflicts', () {
    const medicationId = 3;

    test('Fetch drug-drug interactions for a medication', () async {
      when(
        () => mockApi.get(
          EndPoints.medicationInteraction,
          headers: any(named: 'headers'),
          queryParameters: {
            'filter[medication_id]': medicationId.toString(),
            'filter[interactable_type]': 'medication',
          },
        ),
      ).thenAnswer(
        (_) async => {
          'status': 1,
          'message': 'Interactions fetched successfully',
          'data': [
            {
              'id': 1,
              'medication_id': medicationId,
              'severity': 'severe',
              'description': 'Increases bleeding risk',
              'drug_interaction': {
                'id': 8,
                'image': null,
                'description': 'Blood thinner',
                'form': 'tablet',
                'strength': '75mg',
                'code': {
                  'id': 100,
                  'system': 'RxNorm',
                  'code': '855812',
                  'display': 'Clopidogrel',
                  'category': 'medication',
                  'active': true,
                },
              },
            },
          ],
        },
      );

      final result = await interactionService
          .getInteractions<DrugInteractionModel>(
            'en',
            'token123',
            DrugInteractionModel.fromJson,
            InteractionParams(
              medicationId: medicationId,
              interactableType: 'medication',
            ),
          );

      expect(result.isRight(), true);
      result.fold((_) => fail('expected Right, got Left'), (list) {
        expect(list.data, hasLength(1));
        expect(list.data.first.severity, 'severe');
        expect(list.data.first.drugInteraction.code.display, 'Clopidogrel');
      });
    });

    test('Fetch drug-condition interactions for a medication', () async {
      when(
        () => mockApi.get(
          EndPoints.medicationInteraction,
          headers: any(named: 'headers'),
          queryParameters: {
            'filter[medication_id]': medicationId.toString(),
            'filter[interactable_type]': 'condition',
          },
        ),
      ).thenAnswer(
        (_) async => {
          'status': 1,
          'message': 'Interactions fetched successfully',
          'data': [
            {
              'id': 2,
              'medication_id': medicationId,
              'severity': 'moderate',
              'description': 'Use with caution in renal impairment',
              'condition_interaction': {
                'id': 55,
                'system': 'SNOMED CT',
                'code': '431855005',
                'display': 'Chronic kidney disease',
                'category': 'condition',
                'active': true,
              },
            },
          ],
        },
      );

      final result = await interactionService
          .getInteractions<ConditionInteractionModel>(
            'en',
            'token123',
            ConditionInteractionModel.fromJson,
            InteractionParams(
              medicationId: medicationId,
              interactableType: 'condition',
            ),
          );

      expect(result.isRight(), true);
      result.fold((_) => fail('expected Right, got Left'), (list) {
        expect(
          list.data.single.conditionInteraction.display,
          'Chronic kidney disease',
        );
        expect(list.data.single.severity, 'moderate');
      });
    });

    test('Adding an interaction sends the right multipart fields', () async {
      when(
        () => mockApi.post(
          EndPoints.medicationInteraction,
          headers: any(named: 'headers'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => ApiResponse(statusCode: 201, data: {}));

      final result = await interactionService.addInteraction(
        'en',
        'token123',
        AddInteractionParams(
          medicationId: medicationId,
          interactableType: 'medication',
          interactableId: 8,
          severity: 'severe',
          description: 'Increases bleeding risk',
        ),
      );

      expect(result.isRight(), true);

      final captured = verify(
        () => mockApi.post(
          EndPoints.medicationInteraction,
          headers: any(named: 'headers'),
          data: captureAny(named: 'data'),
        ),
      ).captured;

      final sentFormData = captured.single as FormData;
      final sentFields = {for (final f in sentFormData.fields) f.key: f.value};
      expect(sentFields['medication_id'], medicationId.toString());
      expect(sentFields['interactable_type'], 'medication');
      expect(sentFields['severity'], 'severe');
    });

    test(
      'Registering a duplicate (conflicting) interaction surfaces a 409 error',
      () async {
        when(
          () => mockApi.post(
            EndPoints.medicationInteraction,
            headers: any(named: 'headers'),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          ConflictException(
            ErrorModel(
              status: 409,
              errorMessage: 'This interaction is already registered.',
            ),
          ),
        );

        final result = await interactionService.addInteraction(
          'en',
          'token123',
          AddInteractionParams(
            medicationId: medicationId,
            interactableType: 'medication',
            interactableId: 8,
            severity: 'severe',
            description: 'Increases bleeding risk',
          ),
        );

        expect(result.isLeft(), true);
        result.fold(
          (error) {
            expect(error.status, 409);
            expect(
              error.errorMessage,
              'This interaction is already registered.',
            );
          },
          (_) => fail('expected Left for a conflicting interaction, got Right'),
        );
      },
    );
  });
}
