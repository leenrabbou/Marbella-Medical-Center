import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/encounters/services/encounters_service.dart';
import 'package:mocktail/mocktail.dart';
import '../unit_tests/app_mocks.dart';

void main() {
  late MockApiServices mockApi;
  late EncountersService encountersService;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApi = MockApiServices();
    encountersService = EncountersService(apiService: mockApi);
  });

  Map<String, dynamic> samplePatientJson(int id, String givenName) => {
    'id': id,
    'image': null,
    'given_name': givenName,
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
  };

  Map<String, dynamic> sampleDoctorJson() => {
    'id': 9,
    'image': null,
    'first_name': 'Sami',
    'last_name': 'Khoury',
    'clinic_id': 1,
    'clinic_name': 'Marbella Clinic',
    'gender': 'male',
    'specialization': 'Internal Medicine',
    'brief': 'brief',
    'rating_avg': 4,
    'phone_number': '0944444444',
    'phone_number_verified_at': '22-01-2026',
    'age': 40,
    'ssn': '000',
    'address': 'Damascus',
    'social_history': 'social',
    'marital_status': 'married',
    'experiences': '10 years',
  };

  group('Integration - Encounters Filtering & Pagination', () {
    test(
      'Fetch filtered, paginated encounters matches the real endpoint shape',
      () async {
        const page = 2;
        const patientId = 4;
        final params = EncounterParams(
          search: null,
          status: 'active',
          patientId: patientId,
        );
        when(
          () => mockApi.get(
            '${EndPoints.encounter}?page=$page',
            headers: any(named: 'headers'),
            queryParameters: {
              'filter[status]': 'active',
              'filter[patient_id]': patientId.toString(),
            },
          ),
        ).thenAnswer(
          (_) async => {
            'status': 1,
            'message': 'Encounters fetched successfully',
            'data': {
              'current_page': page,
              'last_page': 3,
              'total': 25,
              'data': [
                {
                  'id': 11,
                  'patient': samplePatientJson(1, 'Leen'),
                  'doctor': sampleDoctorJson(),
                  'status': 'in-progress',
                  'start_time': '01-01-2026 10:00 PM',
                  'end_time': '01-01-2026 11:00 PM',
                  'notes': 'notes',
                  'reason': 'reason',
                },
                {
                  'id': 12,
                  'patient': samplePatientJson(1, 'Leen'),
                  'doctor': sampleDoctorJson(),
                  'status': 'arrived',
                  'start_time': '01-01-2026 12:00 PM',
                  'end_time': '01-01-2026 12:30 PM',
                  'notes': 'notes',
                  'reason': 'reason',
                },
              ],
            },
          },
        );

        final result = await encountersService.getEncounters(
          'en',
          'token123',
          page,
          params,
        );

        expect(result.isRight(), true);
        result.fold((_) => fail('expected Right, got Left'), (list) {
          expect(list.data.currentPage, page);
          expect(list.data.lastPage, 3);
          expect(list.data.total, 25);
          expect(list.data.data, hasLength(2));
          expect(list.data.data.first.patient.givenName, 'Leen');
          expect(list.data.data.first.doctor?.firstName, 'Sami');
          expect(list.data.data.every((e) => e.status.isNotEmpty), isTrue);
        });
      },
    );
  });
}
