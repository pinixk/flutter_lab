import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart'; // mocktail 필수

// 앱 코드 import
import 'package:flutter_lab/main.dart';
import 'package:flutter_lab/core/config/app_config.dart';
import 'package:flutter_lab/features/auth/data/repositories/auth_repository.dart';

// 1. 가짜 인증 리포지토리 만들기
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  testWidgets('앱 실행 시 토큰이 있으면 홈 화면으로 이동한다', (WidgetTester tester) async {
    // 2. [가짜 상황 설정] "토큰 달라고 하면 'fake_token'을 바로 줘라"
    when(() => mockAuthRepository.getAccessToken())
        .thenAnswer((_) async => 'fake_token');

    final testConfig = AppConfig.dev();

    // 3. 앱 실행 (Provider Overrides 중요!)
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // (1) 설정 파일 주입
          appConfigProvider.overrideWithValue(testConfig),
          // (2) [핵심] 실제 저장소 대신 가짜 저장소 주입
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: const MyApp(),
      ),
    );

    // 4. 애니메이션이 끝날 때까지 대기
    // 가짜가 바로 응답하므로 로딩 -> 홈 이동이 순식간에 일어납니다.
    await tester.pumpAndSettle();

    // 5. 검증
    // 로딩이 끝나고 홈 화면(하단 탭)이 떴는지 확인
    expect(find.text('홈'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing); // 로딩바는 사라져야 함
  });
}