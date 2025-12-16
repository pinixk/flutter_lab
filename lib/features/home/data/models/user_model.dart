import 'package:freezed_annotation/freezed_annotation.dart';

// 1. 선언: "이 파일의 짝꿍 파일(.g.dart, .freezed.dart)을 내가 쓸 거야"
part 'user_model.freezed.dart';
part 'user_model.g.dart';

// [마법의 함수] JSON 안쪽 깊숙한 데이터를 쏙 뽑아내는 도우미
// "address 안에 있는 city를 꺼내줘" 라는 로직입니다.
Object? _extractCityFromAddress(Map<dynamic, dynamic> json, String key) {
  // json['address']가 있으면 ['city']를 리턴, 없으면 '서울' 리턴
  return json['address']?['city'] ?? '서울';
}

// 2. @freezed 어노테이션 붙이기
@freezed
class UserModel with _$UserModel {
  // 3. 생성자 정의 (여기만 작성하면 됩니다!)
  // 일반적인 생성자보다 문법이 조금 특이합니다. (factory const)
  const factory UserModel({
    required String name,

    // [Refactor 1] API에 age가 없으면 자동으로 25(또는 0)를 넣음
    @Default(25) int age,

    // [Refactor 2] API의 "address" -> "city" 값을 내 "address" 필드에 매핑
    // readValue 기능을 쓰면 복잡한 JSON도 한방에 처리 가능!
    @JsonKey(readValue: _extractCityFromAddress)
    @Default('서울') String address,
  }) = _UserModel;

  // 4. JSON 변환기 (fromJson) 자동 생성 설정
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}