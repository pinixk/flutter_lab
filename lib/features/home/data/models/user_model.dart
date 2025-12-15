import 'package:freezed_annotation/freezed_annotation.dart';

// 1. 선언: "이 파일의 짝꿍 파일(.g.dart, .freezed.dart)을 내가 쓸 거야"
part 'user_model.freezed.dart';
part 'user_model.g.dart';

// 2. @freezed 어노테이션 붙이기
@freezed
class UserModel with _$UserModel {
  // 3. 생성자 정의 (여기만 작성하면 됩니다!)
  // 일반적인 생성자보다 문법이 조금 특이합니다. (factory const)
  const factory UserModel({
    required String name,
    required int age,
    @Default('서울') String address, // 기본값 설정도 가능
  }) = _UserModel;

  // 4. JSON 변환기 (fromJson) 자동 생성 설정
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}