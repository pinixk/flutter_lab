import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  // [중요] Android의 경우 암호화 옵션을 켜야 안전합니다.
  // 이 옵션이 없으면 구형 기기에서 이슈가 발생할 수 있습니다.
  const androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // iOS는 기본적으로 Keychain을 쓰기 때문에 별도 설정이 필요 없습니다.
  return const FlutterSecureStorage(
    aOptions: androidOptions,
  );
}