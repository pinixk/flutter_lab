import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/home_repository_impl.dart';

part 'home_view_model.g.dart';

// 상태 관리 클래스 (Notifier)
@riverpod
class HomeViewModel extends _$HomeViewModel {
  static const String defaultMessage = '버튼을 눌러보세요';

  // 초기 상태(build) 정의
  @override
  String build() {
    return defaultMessage;
  }

  // 2. 함수 이름을 fetchMessage -> toggleMessage로 변경 (의미를 명확하게)
  void toggleMessage() {
    final repository = ref.read(homeRepositoryProvider);
    final fetchedMessage = repository.fetchWelcomeMessage();

    // [핵심 로직] 현재 상태가 '가져온 데이터'와 같다면? -> 초기화
    // 그게 아니라면? -> 데이터 가져오기
    if (state == fetchedMessage) {
      state = defaultMessage; // 원래대로 복구
    } else {
      state = fetchedMessage; // 데이터로 변경
    }
  }
}