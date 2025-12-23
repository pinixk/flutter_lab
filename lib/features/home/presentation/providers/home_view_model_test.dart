import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_lab/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_lab/features/home/data/models/user_model.dart';
import 'package:flutter_lab/features/home/presentation/providers/home_view_model.dart';

import '../../data/repositories/home_repository_impl.dart';

// 1. 가짜 리포지토리 만들기 (Mock)
class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late ProviderContainer container;

  // 테스트 시작 전 초기화
  setUp(() {
    mockRepository = MockHomeRepository();

    // Riverpod 테스트를 위한 Container 생성
    // [핵심] 실제 Repository 대신 가짜(Mock)를 쓰도록 override 함
    container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  // 테스트 종료 후 정리
  tearDown(() {
    container.dispose();
  });

  test('초기 상태는 로딩 후 데이터를 불러와야 한다', () async {
    // [Given] 가짜 데이터 준비
    const fakeUser = UserModel(name: 'Test User', age: 99, address: 'Test City');

    // Repository가 호출되면 fakeUser를 리턴하라고 조작(Stub)
    when(() => mockRepository.fetchUser()).thenAnswer((_) async => fakeUser);

    // [When] ViewModel을 구독 (build 실행됨)
    // read 대신 listen을 써야 상태 변화를 놓치지 않음
    final subscription = container.listen(homeViewModelProvider, (_, __) {});

    // 비동기 작업이 끝날 때까지 대기
    await container.read(homeViewModelProvider.future);

    // [Then] 상태 검증
    final state = container.read(homeViewModelProvider);

    expect(state.value!.user.name, 'Test User'); // 이름이 맞는지?
    expect(state.value!.user.age, 99); // 나이가 맞는지?

    // Repository의 fetchUser가 진짜로 1번 호출되었는지 검증
    verify(() => mockRepository.fetchUser()).called(1);
  });
}