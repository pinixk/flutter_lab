import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_view_model.dart';

// ConsumerWidget을 상속받아야 ref를 사용할 수 있습니다.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. ViewModel의 상태(state)를 구독합니다. (값이 바뀌면 자동 리빌드)
    final String message = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 2. ViewModel의 함수(메서드)를 실행합니다.
          ref.read(homeViewModelProvider.notifier).toggleMessage();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}