import 'package:mocktail/mocktail.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/core/databases/cache/secure_storage_service.dart';

class MockApiServices extends Mock implements ApiServices {}

class MockCacheService extends Mock implements CacheService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}
