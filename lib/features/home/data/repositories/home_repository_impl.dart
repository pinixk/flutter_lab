import 'package:dio/dio.dart';
import 'package:flutter_lab/core/network/dio_provider.dart';
import 'package:flutter_lab/core/utils/logger_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/home_repository.dart';
import '../models/user_model.dart';

part 'home_repository_impl.g.dart';

// 'implements' 키워드로 계약을 이행합니다.
class HomeRepositoryImpl implements HomeRepository {
  final Dio _dio;
  final Logger _logger;

  HomeRepositoryImpl(this._dio, this._logger);

  @override
  Future<UserModel> fetchUser() async {
    try{
      // 1. 요청 보내기
      final response = await _dio.get('/users/1');
      return UserModel.fromJson(response.data);
    }catch(e){
      _logger.d('🔥🔥🔥 Dio 에러 발생: $e');

      // 2. 만약 DioException이라면 더 자세한 내용을 볼 수 있습니다.
      if (e is DioException) {
        _logger.d('응답 코드: ${e.response?.statusCode}');
        _logger.d('응답 데이터: ${e.response?.data}');
        _logger.e('에러 메시지: ${e.message}');
      }

      throw Exception('데이터 로드 실패: $e');
    }

  }

  @override
  String fetchWelcomeMessage() {
    // 실제로는 여기서 Dio.get('https://api...') 등을 호출합니다.
    return '버튼 누르기 성공!';
  }
}

// [중요] Riverpod이 이 구현체를 포장해서 배달 준비를 합니다.
@riverpod
HomeRepository homeRepository(Ref ref) {
  // 1. Core 레이어에 있는 dioProvider를 읽어옵니다.
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);

  // 2. Repository에 주입(Inject)해서 리턴합니다.
  return HomeRepositoryImpl(dio, logger);
}