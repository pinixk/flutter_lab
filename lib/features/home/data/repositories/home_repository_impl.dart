import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/home_repository.dart';

part 'home_repository_impl.g.dart';

// 'implements' 키워드로 계약을 이행합니다.
class HomeRepositoryImpl implements HomeRepository {
  @override
  String fetchWelcomeMessage() {
    // 실제로는 여기서 Dio.get('https://api...') 등을 호출합니다.
    return '서버에서 가져온 데이터입니다!';
  }
}

// [중요] Riverpod이 이 구현체를 포장해서 배달 준비를 합니다.
@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepositoryImpl();
}