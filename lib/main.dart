import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/router/router_provider.dart';

void main() {

  // 1. 외부에서 주입된 설정값(dart-define)에 따라 Config 객체 생성
  final config = AppConfig.getConfig();

  print('🚀 앱 시작 환경: ${config.flavor} / URL: ${config.baseUrl}');

  runApp(
    ProviderScope(
      overrides: [
        // 2. 결정된 Config로 Provider 덮어쓰기
        appConfigProvider.overrideWithValue(config),
      ],
      child: const MyApp(),
    ),
  );

}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // 1. 우리가 만든 Router Provider를 가져옵니다.
    final config = ref.watch(appConfigProvider);
    final routerConfig = ref.watch(routerProvider);

    return MaterialApp.router(
      title: config.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: routerConfig,
      // DEV 환경일 때만 배너 표시
      debugShowCheckedModeBanner: config.flavor == Flavor.dev,
    );
  }
}