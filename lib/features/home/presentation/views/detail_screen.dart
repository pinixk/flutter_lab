import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_view_model.dart';
import '../providers/home_view_model.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. ViewModel 구독 (AsyncValue)
    final asyncState = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 페이지'),
        actions: [
          // [추가] 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 요청 -> 상태가 unauthenticated로 바뀜 -> 라우터가 감지 -> 로그인 화면으로 이동
              ref.read(authViewModelProvider.notifier).logout();
            },
          ),
        ],
      ), // 제목 변경

      body: asyncState.when(
        // 데이터가 있을 때만 보여줌
        data: (state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                '이름: ${state.user.name}',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                '주소: ${state.user.address}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                '나이: ${state.user.age}세',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        // 로딩이나 에러 처리는 간단하게 (실무에선 공통 위젯 사용)
        error: (err, stack) => Center(child: Text('에러: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
