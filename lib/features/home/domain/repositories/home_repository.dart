// abstract(추상) 클래스로 만듭니다.
// "구현은 나중에 data 계층에서 알아서 해, 난 몰라." 라는 뜻입니다.
import 'package:flutter_lab/features/home/data/models/user_model.dart';

abstract class HomeRepository {
  String fetchWelcomeMessage();

  // Future<UserModel>을 반환한다는 것은
  // "지금 당장은 없지만, 기다리면 UserModel을 줄게"라는 뜻입니다.
  Future<UserModel> fetchUser();
}