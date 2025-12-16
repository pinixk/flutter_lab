import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_view_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 로그인 상태를 지켜봅니다 (로딩 중일 때 버튼 비활성화 등을 위해)
    final authState = ref.watch(authViewModelProvider);

    // 로딩 중인지 확인
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 30),

            // 이메일 입력
            TextField(
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading, // 로딩 중엔 입력 막기
            ),
            const SizedBox(height: 16),

            // 비밀번호 입력
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading,
            ),
            const SizedBox(height: 30),

            // 로그인 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null // 로딩 중이면 버튼 클릭 방지
                    : () {
                  // ViewModel의 login 함수 호출
                  ref.read(authViewModelProvider.notifier).login(
                    email: 'test@test.com',
                    password: 'password',
                  );
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('로그인', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}