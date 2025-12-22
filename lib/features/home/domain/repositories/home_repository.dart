// abstract(추상) 클래스로 만듭니다.
// "구현은 나중에 data 계층에서 알아서 해, 난 몰라." 라는 뜻입니다.
import 'dart:io';

import 'package:flutter_lab/features/home/data/models/user_model.dart';

abstract class HomeRepository {
  String fetchWelcomeMessage();

  // Future<UserModel>을 반환한다는 것은
  // "지금 당장은 없지만, 기다리면 UserModel을 줄게"라는 뜻입니다.
  Future<UserModel> fetchUser();

  // [New] 이미지 업로드 계약 추가
  // 파일을 보내면 -> 서버가 갱신된 유저 정보(새 이미지 URL 포함)를 준다고 가정
  Future<UserModel> uploadProfileImage(File imageFile);
}