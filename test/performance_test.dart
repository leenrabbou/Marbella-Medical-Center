// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:dio/dio.dart';
// import 'package:marbella/core/databases/api/end_points.dart';

// void main() {
//   late Dio dio;

//   setUp(() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: 'Url',
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//       ),
//     );
//   });

//   Future<void> measurePerformance({
//     required String operationName,
//     required Future<Response> Function() request,
//     required int expectedStatusCode,
//   }) async {
//     const numberOfRuns = 10;
//     final times = <int>[];

//     for (int i = 0; i < numberOfRuns; i++) {
//       final stopwatch = Stopwatch()..start();

//       final response = await request();

//       stopwatch.stop();

//       expect(response.statusCode, expectedStatusCode);

//       times.add(stopwatch.elapsedMilliseconds);
//     }

//     final sortedTimes = [...times]..sort();

//     final minimum = sortedTimes.first;
//     final maximum = sortedTimes.last;

//     final average =
//         times.reduce((value, element) => value + element) / times.length;

//     final median = times.length.isOdd
//         ? sortedTimes[times.length ~/ 2].toDouble()
//         : (sortedTimes[times.length ~/ 2 - 1] +
//                   sortedTimes[times.length ~/ 2]) /
//               2;

//     if (kDebugMode) {
//       print('\n========== $operationName ==========');
//     }
//     if (kDebugMode) {
//       print('Runs: $numberOfRuns');
//     }
//     if (kDebugMode) {
//       print('Times: $times ms');
//     }
//     if (kDebugMode) {
//       print('Minimum: $minimum ms');
//     }
//     if (kDebugMode) {
//       print('Maximum: $maximum ms');
//     }
//     if (kDebugMode) {
//       print('Average: ${average.toStringAsFixed(2)} ms');
//     }
//     if (kDebugMode) {
//       print('Median: ${median.toStringAsFixed(2)} ms');
//     }
//   }

//   group('Real API Performance Benchmarks', () {
//     test('Real Login API Performance', () async {
//       await measurePerformance(
//         operationName: 'Login API',
//         expectedStatusCode: 200,
//         request: () {
//           return dio.post(
//             EndPoints.login,
//             data: {'phone_number': '0922222222', 'password': '11111111'},
//           );
//         },
//       );
//     });

//     test('Real Fetch Patients API Performance', () async {
//       await measurePerformance(
//         operationName: 'Fetch Patients API',
//         expectedStatusCode: 200,
//         request: () {
//           return dio.get(
//             EndPoints.getPatients,
//             options: Options(
//               headers: {'locale': 'en', 'Authorization': 'BACKEND_TOKEN'},
//             ),
//           );
//         },
//       );
//     });

//     test('Real Send Notification API Performance', () async {
//       await measurePerformance(
//         operationName: 'Send Notification API',
//         expectedStatusCode: 200,
//         request: () {
//           return dio.post(
//             '${EndPoints.notifications}/send',
//             data: {
//               'user_id': '3',
//               'title_ar': 'Appointment Reminder',
//               'title_en': 'Appointment Reminder',
//               'body_ar':
//                   'Your appointment is scheduled for tomorrow at 10:00 AM',
//               'body_en':
//                   'Your appointment is scheduled for tomorrow at 10:00 AM',
//             },
//           );
//         },
//       );
//     });

//     test('Real Create Medical Note API Performance', () async {
//       await measurePerformance(
//         operationName: 'Create Medical Note API',
//         expectedStatusCode: 201,
//         request: () {
//           return dio.post(
//             EndPoints.encounterNote,
//             options: Options(
//               headers: {'locale': 'en', 'Authorization': 'BACKEND_TOKEN'},
//             ),
//             data: {
//               'encounter_id': 8,
//               'title': 'title',
//               'note': 'note',
//               'duration_unit': 'months',
//               'duration_value': 4,
//             },
//           );
//         },
//       );
//     });
//   });
// }
