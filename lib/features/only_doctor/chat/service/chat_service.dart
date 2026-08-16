import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_list_model.dart';
import 'package:marbella/features/only_doctor/chat/Models/message_model.dart';
import 'package:marbella/features/only_doctor/chat/Models/messages_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class ChatService {
  ApiServices apiService;
  ChatService({required this.apiService});

  Future<Either<ErrorModel, ConversationListModel>> getConversations(
    String locale,
    String? token,
    int page,
  ) async {
    try {
      String url = "${EndPoints.chatConversations}?page=$page";
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = ConversationListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, MessagesListModel>> getMessages(
    String locale,
    String? token,
    int page,
    int conversationId,
  ) async {
    try {
      String url =
          "${EndPoints.chatConversations}/$conversationId/${EndPoints.messages}?page=$page";
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = MessagesListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, MessageModel?>> sendMessage(
    String locale,
    String token,
    MessageParams params,
    int conversationId,
  ) async {
    try {
      final hasAttachments = params.attachments.isNotEmpty;

      final dynamic data = hasAttachments
          ? FormData.fromMap({
              ApiKey.message: params.message,
              '${ApiKey.attachments}[]': [
                for (final file in params.attachments)
                  await MultipartFile.fromFile(
                    file.path,
                    filename: file.path.split('/').last,
                  ),
              ],
            })
          : {ApiKey.message: params.message};

      final response = await apiService.post(
        "${EndPoints.chatConversations}/$conversationId/${EndPoints.messages}",
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: data,
      );

      if (response.statusCode == 201) {
        final body = response.data;
        final messageJson = body is Map && body[ApiKey.data] != null
            ? body[ApiKey.data]
            : null;
        return Right(
          messageJson != null ? MessageModel.fromJson(messageJson) : null,
        );
      }
      final error = ErrorModel(
        status: response.statusCode,
        errorMessage: response.error?.errorMessage ?? S().unknown_error,
      );
      return Left(error);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
