import 'package:flutter_lab/features/home/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/home_repository_impl.dart';

part 'home_view_model.freezed.dart'; // [중요] 파일명.freezed.dart 추가
part 'home_view_model.g.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default('버튼을 눌러보세요') String message, // 메시지 상태 (기본값 설정)
    @Default(UserModel(name: '김코딩', age: 25)) UserModel user, // 유저 상태
    @Default(false) bool isLoading, // (보너스) 로딩 상태까지 추가 가능!
  }) = _HomeState;
}

// 상태 관리 클래스 (Notifier)
@riverpod
class HomeViewModel extends _$HomeViewModel {
  // 초기 상태(build) 정의
  @override
  HomeState build() {
    return const HomeState();
  }

  // --- 기능 1: 메시지 토글 (String 제어) ---
  // 2. 함수 이름을 fetchMessage -> toggleMessage로 변경 (의미를 명확하게)
  void toggleMessage() {
    final repository = ref.read(homeRepositoryProvider);

    final fetchedMessage = repository.fetchWelcomeMessage();
    const defaultMsg = '버튼을 눌러보세요';

    // [핵심 로직] 현재 상태가 '가져온 데이터'와 같다면? -> 초기화
    // 그게 아니라면? -> 데이터 가져오기
    if (state.message == fetchedMessage) {
      state = state.copyWith(message: defaultMsg); // 원래대로 복구
    } else {
      state = state.copyWith(message: fetchedMessage); // 데이터로 변경
    }
  }

  // --- 기능 2: 유저 정보 수정 (UserModel 제어) ---
  void updateName() {
    // [중요] state 안에 user가 있고, 그 안에 copyWith가 또 있습니다.
    // "전체 상태(HomeState)를 복사하는데, 그 안의 user를 새것으로 바꾸겠다"
    state = state.copyWith(
      user: state.user.copyWith(name: '이수정'),
    );
  }

  void incrementAge() {
    state = state.copyWith(
      user: state.user.copyWith(age: state.user.age + 1),
    );
  }
}