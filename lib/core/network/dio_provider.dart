import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

// 앱 전체에서 단 하나만 존재하는 Dio 객체 (Singleton 개념)
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio();

  // 타임아웃 설정 (서버가 5초 동안 응답 없으면 에러 처리)
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);

  // 기본 BaseURL 설정 (이후 요청은 뒷부분 경로만 적으면 됨)
  dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';

  // (팁) 나중에 여기에 로그 출력(Interceptor) 등을 추가하면 디버깅이 편해집니다.

  return dio;
}