import 'dart:io';

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

  // [New] 구현 로직
  @override
  Future<UserModel> uploadProfileImage(File imageFile) async {
    try {
      _logger.d('이미지 업로드 시작: ${imageFile.path}');

      // 1. 파일 이름 추출 (예: image.jpg)
      String fileName = imageFile.path.split('/').last;

      // 2. FormData 생성 (파일 전송용 데이터 포맷)
      FormData formData = FormData.fromMap({
        // 서버에서 요구하는 key 이름이 'file'이라고 가정
        // await MultipartFile.fromFile 은 파일을 비동기로 읽어옵니다.
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        // 필요하다면 다른 필드도 같이 보낼 수 있음
        // 'userId': 1,
      });

      // 3. 서버 전송 (POST or PUT)
      // JSONPlaceholder는 실제 파일 업로드를 지원하지 않으므로
      // 여기서는 가상의 주소로 보내고, 로컬 데이터를 리턴하는 척 흉내만 냅니다.
      // 실제 서버라면: final response = await _dio.post('/users/1/image', data: formData);

      // (서버 시뮬레이션 딜레이)
      await Future.delayed(const Duration(seconds: 2));
      _logger.i('이미지 업로드 성공 (시뮬레이션)');

      // 4. 서버가 준 최신 유저 정보 리턴 (가정)
      // 실제로는 response.data를 파싱해야 함.
      // 여기서는 기존 데이터를 유지한다고 가정.
      return const UserModel(
        name: 'Leanne Graham',
        age: 25,
        address: 'Gwenborough',
      );

    } catch (e, stackTrace) {
      _logger.e('이미지 업로드 실패', error: e, stackTrace: stackTrace);
      throw Exception('업로드 실패: $e');
    }
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