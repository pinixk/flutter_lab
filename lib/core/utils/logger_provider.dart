import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_provider.g.dart';

@riverpod
Logger logger(Ref ref){
  return Logger(
    printer: PrettyPrinter(
      methodCount: 1, // 로그 찍은 메소드 1개까지만 보여줌 (깔끔하게)
      errorMethodCount: 5, // 에러는 5단계까지 추적
      lineLength: 80, // 줄바꿈 길이
      colors: true, // 알록달록하게
      printEmojis: true, // 이모지 사용 (🚀, ⛔ 등)
    ),
  );
}