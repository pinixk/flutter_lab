import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  // 1. 주소와 에러 메시지를 외부에서 받도록 변수 선언
  final String uri;
  final Exception? error;

  const NotFoundScreen({
    super.key,
    required this.uri,
    this.error
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('페이지를 찾을 수 없음')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              '요청하신 페이지가 존재하지 않습니다.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              // 2. 이제 context가 아니라 변수(uri)를 바로 출력
              '경로: $uri',
              style: const TextStyle(color: Colors.grey),
            ),
            if (error != null)
              Text(
                '에러: $error',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}