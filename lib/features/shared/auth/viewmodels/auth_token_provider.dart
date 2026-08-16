import 'dart:convert';

import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/databases/cache/secure_storage_service.dart';
import 'package:marbella/features/shared/auth/models/user_model.dart';

abstract class AuthTokenProvider {
  Future<String?> getToken();
}

class SecureStorageTokenProvider implements AuthTokenProvider {
  final SecureStorageService secureStorage;
  SecureStorageTokenProvider(this.secureStorage);

  @override
  Future<String?> getToken() async {
    final cached = await secureStorage.read(key: CacheKeys.userKey);
    if (cached == null) return null;
    return UserModel.fromJson(jsonDecode(cached)).token;
  }
}
