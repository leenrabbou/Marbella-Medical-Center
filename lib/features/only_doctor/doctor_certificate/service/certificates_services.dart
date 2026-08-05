import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/models/certificates_list_model.dart';

class CertificatesServices {
  ApiServices apiService;
  CertificatesServices({required this.apiService});

  Future<Either<ErrorModel, CertificatesListModel>> getCertificates(
    String locale,
    String? token,
    int page,
  ) async {
    try {
      String url = "${EndPoints.doctorCertificate}?page=$page";
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = CertificatesListModel.fromJson(response);

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
