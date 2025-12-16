import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/secure_storage_provider.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FlutterSecureStorage _storage;

  AuthRepository(this._storage);

  // 저장소의 Key 값은 상수로 관리하는 게 좋습니다.
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  // 1. 토큰 저장 (로그인 성공 시)
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // 2. 토큰 조회 (자동 로그인 시)
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // 3. 토큰 삭제 (로그아웃 시)
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}

// Provider 생성
@riverpod
AuthRepository authRepository(Ref ref) {
  // Core에 있는 SecureStorage를 가져옵니다.
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(storage);
}
