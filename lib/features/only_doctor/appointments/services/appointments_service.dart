import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_details_model.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointments_list_model.dart';

class AppointmentsService {
  ApiServices apiService;
  AppointmentsService({required this.apiService});

  Future<Either<ErrorModel, AppointmentsListModel>> getAppointments(
    String locale,
    String token,
    AppointmentsParams params,
  ) async {
    try {
      final Map<String, String> queryParams = {};

      if (params.dateRangeFrom != null && params.dateRangeTo != null) {
        queryParams['filter[date_range][from]'] = params.dateRangeFrom!;
        queryParams['filter[date_range][to]'] = params.dateRangeTo!;
      }

      if (params.status != null) {
        queryParams['filter[status]'] = params.status!;
      }

      if (params.patientId != null) {
        queryParams['filter[patient_id]'] = params.patientId.toString();
      }

      final response = await apiService.get(
        EndPoints.appointment,
        headers: {'locale': locale, 'Authorization': 'Bearer $token'},
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response[ApiKey.status] == 1) {
        return Right(AppointmentsListModel.fromJson(response));
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, AppointmentDetailsModel>> getAppointmentDetails(
    String locale,
    String? token,
    int id,
  ) async {
    try {
      final response = await apiService.get(
        "${EndPoints.appointment}/$id",
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = AppointmentDetailsModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
