import 'package:dio/dio.dart';
import 'package:flutter_lab/core/network/auth_interceptor.dart';
import 'package:flutter_lab/core/utils/logger_provider.dart';
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

  // ref를 넘겨줘서 인터셉터 안에서 다른 Provider를 부를 수 있게 합니다.
  dio.interceptors.add(AuthInterceptor(ref, logger(ref)));

  // (팁) 개발 모드일 때만 로그를 예쁘게 찍어주는 패키지가 있다면 추가해도 좋습니다.
  // dio.interceptors.add(LogInterceptor());

  return dio;
}