import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

enum Flavor { dev, prod }

class AppConfig {
  final Flavor flavor;
  final String baseUrl;
  final String appTitle;

  AppConfig({
    required this.flavor,
    required this.baseUrl,
    required this.appTitle,
  });

  factory AppConfig.dev() {
    return AppConfig(
      flavor: Flavor.dev,
      baseUrl: 'https://jsonplaceholder.typicode.com',
      appTitle: '[DEV] Flutter Lab',
    );
  }

  factory AppConfig.prod() {
    return AppConfig(
      flavor: Flavor.prod,
      baseUrl: 'https://api.real-server.com',
      appTitle: 'Flutter Lab',
    );
  }

  // [New] 현재 환경을 판단하는 정적 함수
  // --dart-define=FLAVOR=prod 라고 입력하면 'prod'를 읽어옵니다.
  static AppConfig getConfig() {
    // const String.fromEnvironment는 컴파일 타임에 값을 읽어옵니다.
    const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

    if (flavorString == 'prod') {
      return AppConfig.prod();
    } else {
      return AppConfig.dev();
    }
  }
}

// Provider는 값을 오버라이드 할 것이므로 그대로 둡니다.
@riverpod
AppConfig appConfig(AppConfigRef ref) {
  throw UnimplementedError('main.dart에서 override 해줘야 합니다.');
}