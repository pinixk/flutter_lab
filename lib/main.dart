// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Riverpod을 사용하려면 앱 전체를 ProviderScope으로 감싸야 해
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 나중에 GoRouter를 사용할 때 이 부분을 RouterWidget으로 교체할 거야
      home: Container(
        color: Colors.white,
      ), // 임시로 Placeholder를 넣어둘게
    );
  }
}