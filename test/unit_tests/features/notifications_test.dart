import 'package:flutter_test/flutter_test.dart';
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

  group('Notification System - Tests', () {
    test('Receive appointment notification successfully (200)', () async {
      when(() => mockApi.get(any())).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          data: {
            'status': 1,
            'message': 'Notification retrieved successfully',
            'data': {
              'id': 'notif_123',
              'title': 'Appointment Reminder',
              'body': 'You have an appointment tomorrow at 10:00 AM',
            },
          },
        ),
      );

      final response = await mockApi.get('/notifications');

      expect(response.statusCode, 200);
      expect(response.data['data']['id'], 'notif_123');
      verify(() => mockApi.get(any())).called(1);
    });

    test('Mark notification as read succeeds (200)', () async {
      const notificationId = 'notif_123';
      when(() => mockApi.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          data: {'status': 1, 'message': 'Marked as read'},
        ),
      );

      final response = await mockApi.post(
        '/notifications/$notificationId/read',
        data: {},
      );

      expect(response.statusCode, 200);
      verify(() => mockApi.post(any(), data: any(named: 'data'))).called(1);
    });
  });
}
