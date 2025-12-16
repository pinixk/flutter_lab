import 'package:dio/dio.dart';
import 'package:flutter_lab/core/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/home_repository.dart';
import '../models/user_model.dart';

part 'home_repository_impl.g.dart';

// 'implements' 키워드로 계약을 이행합니다.
class HomeRepositoryImpl implements HomeRepository {
  final Dio _dio;

  HomeRepositoryImpl(this._dio);

  @override
  Future<UserModel> fetchUser() async {
    try{
      // 1. 요청 보내기
      final response = await _dio.get('/users/1');

      // [추가] 실제로 요청한 전체 주소 찍어보기
      print('🚀 실제 요청 URL: ${response.realUri}');

      final data = response.data;

      // JSON 데이터를 UserModel로 변환
      // API 응답에 age가 없어서 임의값, city를 address로 매핑
      return UserModel(
          name: data['name'],
          age: 25
      );
    }catch(e){
      print('🔥🔥🔥 Dio 에러 발생: $e');

      // 2. 만약 DioException이라면 더 자세한 내용을 볼 수 있습니다.
      if (e is DioException) {
        print('응답 코드: ${e.response?.statusCode}');
        print('응답 데이터: ${e.response?.data}');
        print('에러 메시지: ${e.message}');
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

  // 2. Repository에 주입(Inject)해서 리턴합니다.
  return HomeRepositoryImpl(dio);
}