import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/patients/services/patients_service.dart';
import 'package:mocktail/mocktail.dart';
import '../unit_tests/app_mocks.dart';

void main() {
  late MockApiServices mockApi;
  late PatientsService patientsService;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApi = MockApiServices();
    patientsService = PatientsService(apiService: mockApi);
  });

  group('Integration - Patient List Fetching from Backend', () {
    test(
      'Fetch patients list from backend and verify parsed structure',
      () async {
        when(
          () => mockApi.get(
            EndPoints.getPatients,
            queryParameters: any(named: 'queryParameters'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => {
            'status': 1,
            'message': 'Patients fetched successfully',
            'data': {
              'current_page': 1,
              'last_page': 1,
              'data': [
                {
                  'id': 1,
                  'image': null,
                  'given_name': 'Leen',
                  'family_name': 'Rabbou',
                  'gender': 'female',
                  'phone_number': '0922222222',
                  'phone_number_verified_at': '22-01-2026',
                  'date_of_birth': '22-01-2004',
                  'national_id': '1234567891',
                  'social_history': 'social',
                  'occupation': 'SE',
                  'marital_status': 'single',
                  'blood_group': 'AB+',
                  'active': true,
                  'notes': 'note',
                },
                {
                  'id': 2,
                  'image': null,
                  'given_name': 'rima',
                  'family_name': 'Rabbou',
                  'gender': 'female',
                  'phone_number': '0933333333',
                  'phone_number_verified_at': '22-01-2026',
                  'date_of_birth': '22-01-2004',
                  'national_id': '1234567892',
                  'social_history': 'social',
                  'occupation': 'SE',
                  'marital_status': 'single',
                  'blood_group': 'AB+',
                  'active': true,
                  'notes': 'note',
                },
              ],
            },
          },
        );

        final result = await patientsService.getPatients(
          'en',
          'token123',
          1,
          PatientsParams(search: null),
        );

        expect(result.isRight(), true);
        result.fold((_) => fail('expected Right, got Left'), (list) {
          expect(list.data.data, hasLength(2));
          expect(list.data.data.first.givenName, 'Leen');
          expect(list.data.data.first.active, isTrue);
          expect(list.data.currentPage, 1);
        });
      },
    );

    test(
      'Fetch patients list fails when backend reports status != 1',
      () async {
        when(
          () => mockApi.get(
            EndPoints.getPatients,
            queryParameters: any(named: 'queryParameters'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => {'status': 0, 'message': 'Unauthenticated.'});

        final result = await patientsService.getPatients(
          'en',
          'expired-token',
          1,
          PatientsParams(search: null),
        );

        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error.errorMessage, 'Unauthenticated.'),
          (_) => fail('expected Left, got Right'),
        );
      },
    );
  });
}
