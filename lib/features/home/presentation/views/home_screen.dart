import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_view_model.dart';

// ConsumerWidget을 상속받아야 ref를 사용할 수 있습니다.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. ViewModel의 상태(state)를 구독합니다. (값이 바뀌면 자동 리빌드)
    final state = ref.watch(homeViewModelProvider);

    // 2. 상자 안에서 필요한 것들을 꺼냅니다.
    final message = state.message;
    final user = state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('통합 상태 관리')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 메시지(String) 보여주기
            Text(
              message,
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const Divider(height: 40, thickness: 2), // 구분선

            // 유저 정보(UserModel) 보여주기
            Text('이름: ${user.name}', style: const TextStyle(fontSize: 24)),
            Text('나이: ${user.age}', style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 메시지 토글 버튼
          FloatingActionButton.extended(
            heroTag: 'msg',
            onPressed: () => ref.read(homeViewModelProvider.notifier).toggleMessage(),
            label: const Text('메시지 변경'),
            icon: const Icon(Icons.message),
          ),
          const SizedBox(height: 10),

          // 이름 변경 버튼
          FloatingActionButton.extended(
            heroTag: 'name',
            onPressed: () => ref.read(homeViewModelProvider.notifier).updateName(),
            label: const Text('이름 변경'),
            icon: const Icon(Icons.person),
          ),
          const SizedBox(height: 10),

          // 나이 증가 버튼
          FloatingActionButton.extended(
            heroTag: 'age',
            onPressed: () => ref.read(homeViewModelProvider.notifier).incrementAge(),
            label: const Text('나이 +1'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}