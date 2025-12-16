import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository.dart';

part 'auth_view_model.g.dart';

// 1. 인증 상태를 나타내는 열거형 (Enum)
enum AuthStatus {
  unknown,          // 앱 켜지는 중 (토큰 확인 전)
  authenticated,    // 로그인 됨
  unauthenticated,  // 로그인 안 됨
}

@riverpod
class AuthViewModel extends _$AuthViewModel {

  // 2. 초기화 (앱 켤 때 토큰 검사)
  @override
  Future<AuthStatus> build() async {
    // Repository에게 "저장된 토큰 있어?" 라고 물어봅니다.
    final repository = ref.watch(authRepositoryProvider);
    final token = await repository.getAccessToken();

    // 토큰이 있으면 '로그인 됨', 없으면 '안 됨' 반환
    if (token != null && token.isNotEmpty) {
      return AuthStatus.authenticated;
    } else {
      return AuthStatus.unauthenticated;
    }
  }

  // 3. 로그인 동작
  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);

      // (실제로는 여기서 서버 API를 호출해서 토큰을 받아와야 합니다.)
      // 지금은 학습용이니 가짜 토큰을 바로 저장하겠습니다.
      await repository.saveTokens(
        accessToken: 'fake_access_token_abc123',
        refreshToken: 'fake_refresh_token_xyz987',
      );

      return AuthStatus.authenticated; // 상태 변경 -> 로그인 됨!
    });
  }

  // 4. 로그아웃 동작
  Future<void> logout() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);

      // 저장소에서 토큰 삭제
      await repository.clearTokens();

      return AuthStatus.unauthenticated; // 상태 변경 -> 로그인 안 됨!
    });
  }
}
