import 'package:flutter_lab/features/home/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/home_repository_impl.dart';

part 'home_view_model.freezed.dart'; // [중요] 파일명.freezed.dart 추가
part 'home_view_model.g.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default('데이터 불러오는 중...') String message, // 메시지 상태 (기본값 설정)
    @Default(UserModel(name: '김코딩', age: 25)) UserModel user, // 유저 상태
  }) = _HomeState;
}

// 상태 관리 클래스 (Notifier)
@riverpod
class HomeViewModel extends _$HomeViewModel {
  // 초기 상태(build) 정의
  @override
  Future<HomeState> build() async {
    return  HomeState(
      message: '서버 데이터 로드 완료!',
      user: UserModel(name: '김아무개', age: 25),
    );
  }

  // --- 기능 1: 메시지 토글 (String 제어) ---
  // 2. 함수 이름을 fetchMessage -> toggleMessage로 변경 (의미를 명확하게)
  void toggleMessage() async {
    final currentState = state.value;
    if(currentState == null) return;

    final repository = ref.read(homeRepositoryProvider);

    final fetchedMessage = repository.fetchWelcomeMessage();
    const defaultMsg = '버튼을 눌러보세요';

    // [핵심 로직] 현재 상태가 '가져온 데이터'와 같다면? -> 초기화
    // 그게 아니라면? -> 데이터 가져오기
    if (currentState.message == fetchedMessage) {
      state = AsyncValue.data(
        currentState.copyWith(message: defaultMsg) // 디폴트로 변경
      );
    } else {
      state =AsyncValue.data(
        currentState.copyWith(message: fetchedMessage)
      );
    }
  }

  // --- 기능 2: 유저 정보 수정 (UserModel 제어) ---
  void updateName() async {
    final currentState = state.value;
    if(currentState == null) return;

    final repository = ref.watch(homeRepositoryProvider);
    final user = await repository.fetchUser();


    // 1. 화면을 로딩 상태로 바꿈 (낙관적 업데이트가 아니라면)
    state = const AsyncValue.loading();

    // 2. AsyncValue.guard: 에러 처리를 자동으로 해주는 마법의 도구
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 1));

      return currentState.copyWith(
          user: currentState.user.copyWith(name: user.name)
      );
    }
    );
  }

  void incrementAge() async {
    final currentState = state.value;
    if(currentState == null) return;

    state = AsyncValue.data(
      currentState.copyWith(
        user: currentState.user.copyWith(age: currentState.user.age + 1)
      )
    );
  }
}