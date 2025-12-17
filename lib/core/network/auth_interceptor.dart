import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_view_model.dart';

// Interceptor 클래스를 상속받아 구현합니다.
class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  // 1. 요청(Request)을 가로채서 토큰 심기
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('🛫 [Request] ${options.method} ${options.uri}');

    // (1) 토큰이 필요 없는 요청인지 확인 (로그인 API 등)
    if (options.headers['accessToken'] == 'false') {
      // 헤더를 지우고 그대로 통과
      options.headers.remove('accessToken');
      return handler.next(options);
    }

    // (2) 저장소에서 토큰 꺼내기
    // *주의: Repository는 Provider로 관리되므로 ref.read로 가져옵니다.
    final repository = ref.read(authRepositoryProvider);
    final token = await repository.getAccessToken();

    // (3) 헤더에 실제 토큰 집어넣기
    if (token != null) {
      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      print('🔑 토큰 주입 완료');
    }


    // [테스트용] 홈 화면에서 요청할 때 강제로 에러 내보기
    // if (options.uri.path.contains('/users/1')) {
    //   // 일부러 401 에러를 흉내낸 DioException을 던짐 (테스트 끝나면 지우세요!)
    //   return handler.reject(
    //     DioException(
    //       requestOptions: options,
    //       response: Response(requestOptions: options, statusCode: 401),
    //       type: DioExceptionType.badResponse,
    //     ),
    //   );
    // }

    // 다음 단계로 진행 (실제 전송)
    return handler.next(options);
  }

  // 2. 응답(Response)을 가로채기 (로그 등)
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('🛬 [Response] ${response.statusCode} ${response.requestOptions.uri}');
    return handler.next(response);
  }

  // 3. 에러(Error)를 가로채서 401 처리
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('🚨 [Error] ${err.response?.statusCode} : ${err.requestOptions.uri}');

    // (1) 401 Unauthorized 에러가 떴을 때 (토큰 만료 등)
    if (err.response?.statusCode == 401) {
      print('👋 토큰이 만료되었습니다. 강제 로그아웃 진행.');

      // (2) 뷰모델을 통해 로그아웃 실행 -> 라우터가 감지하고 로그인 화면으로 보냄
      // *주의: 여기서 await를 하면 데드락이 걸릴 수 있으므로 실행만 시킵니다.
      ref.read(authViewModelProvider.notifier).logout();

      // 에러를 그대로 던져서 UI가 알게 하거나, handler.resolve()로 에러를 숨길 수도 있습니다.
      // 여기서는 일단 에러를 던집니다.
    }

    return handler.next(err);
  }
}