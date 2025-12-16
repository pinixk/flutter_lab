import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 이제 viewModel은 AsyncValue<HomeState> 타입입니다.
    final asyncState = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('API 통신 & 비동기 처리')),
      // 2. [핵심] .when을 사용하여 3가지 상태를 우아하게 처리합니다.
      body: asyncState.when(
        // (1) 데이터가 성공적으로 로드되었을 때
        data: (state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: const TextStyle(color: Colors.blue)),
                const SizedBox(height: 20),
                Text('이름: ${state.user.name}', style: const TextStyle(fontSize: 24)),
                Text('주소: ${state.user.address}', style: const TextStyle(fontSize: 24)),
                Text('나이: ${state.user.age}', style: const TextStyle(fontSize: 24)),
              ],
            ),
          );
        },
        // (2) 에러가 발생했을 때
        error: (err, stack) => Center(
          child: Text('에러 발생: $err', style: const TextStyle(color: Colors.red)),
        ),
        // (3) 로딩 중일 때 (초기 로딩 or state = AsyncValue.loading() 일 때)
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'update',
            // 데이터가 있을 때만 버튼 동작
            onPressed: () => ref.read(homeViewModelProvider.notifier).updateName(),
            label: const Text('이름 변경 (서버 흉내)'),
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'age',
            onPressed: () => ref.read(homeViewModelProvider.notifier).incrementAge(),
            label: const Text('나이 +1 (즉시)'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}