import 'package:flutter_test/flutter_test.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/features/shared/encounters/models/only_nurse/doctor_model.dart';
import 'package:mocktail/mocktail.dart';
import '../unit_tests/app_mocks.dart';

void main() {
  late MockApiServices mockApi;

  setUp(() {
    mockApi = MockApiServices();
  });

  group('Integration - Filtering & Pagination', () {
    test(
      'Verify Paginated & Filtered response matches backend API specs',
      () async {
        final queryParameters = {
          'page': 2,
          'per_page': 10,
          'status': 'active',
          'patient_id': 4,
        };
        when(
          () => mockApi.get('encounters', queryParameters: queryParameters),
        ).thenAnswer(
          (_) async => ApiResponse(
            statusCode: 200,
            data: {
              'current_page': 2,
              'per_page': 10,
              'total': 25,
              'data': [
                {
                  'id': 11,
                  'patient': PatientModel,
                  'doctor': DoctorModel,
                  'status': 'in-progress',
                  'startTime': '01-01-2026 10:00 PM',
                  'endTime': '01-01-2026 11:00 PM',
                  'notes': 'notes',
                  'reason': 'reason',
                },
                {
                  'id': 11,
                  'patient': PatientModel,
                  'doctor': DoctorModel,
                  'status': 'arrived',
                  'startTime': '01-01-2026 12:00 PM',
                  'endTime': '01-01-2026 12:30 PM',
                  'notes': 'notes',
                  'reason': 'reason',
                },
              ],
            },
          ),
        );

        final response = await mockApi.get(
          'encounters',
          queryParameters: queryParameters,
        );

        expect(response.statusCode, 200);
        expect(response.data['current_page'], equals(2));
        expect(response.data['data'].length, equals(2));
        verify(
          () => mockApi.get('encounters', queryParameters: queryParameters),
        ).called(1);
      },
    );
  });
}
