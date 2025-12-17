import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository_impl.dart';

part 'post_view_model.g.dart';

// 상태: 그냥 List<PostModel>을 관리합니다.
@riverpod
class PostViewModel extends _$PostViewModel {
  // 내부 변수로 현재 페이지와 로딩 상태를 관리
  int _page = 1;
  bool _hasNext = true; // 더 가져올 데이터가 있는지?
  bool _isLoading = false; // 중복 요청 방지용

  @override
  Future<List<PostModel>> build() async {
    // 첫 페이지(1페이지) 로드
    _page = 1;
    _hasNext = true;
    _isLoading = false;

    final repository = ref.watch(postRepositoryProvider);
    return await repository.fetchPosts(page: _page);
  }

  // [핵심] 다음 페이지 불러오기 (Load More)
  Future<void> loadMore() async {
    // 1. 방어 코드: 이미 로딩 중이거나, 더 이상 데이터가 없으면 무시
    if (_isLoading || !_hasNext) return;

    // 2. 로딩 시작 표시 (state를 로딩으로 바꾸진 않음! 바닥에만 표시할 거라)
    _isLoading = true;

    try {
      // 3. 다음 페이지 요청
      final repository = ref.read(postRepositoryProvider);
      final newPosts = await repository.fetchPosts(page: _page + 1);

      if (newPosts.isEmpty) {
        _hasNext = false; // 더 이상 데이터 없음
      } else {
        _page++; // 페이지 번호 증가

        // 4. [상태 업데이트] 기존 데이터 + 새 데이터 합치기
        // state.value에는 현재 화면에 보이는 리스트가 들어있습니다.
        final oldPosts = state.value ?? [];

        // Riverpod의 state 갱신 -> 화면 리빌드
        state = AsyncValue.data([...oldPosts, ...newPosts]);
      }
    } catch (e) {
      // 에러 처리는 스낵바 등으로 (여기선 생략)
      print('추가 로드 실패: $e');
    } finally {
      _isLoading = false; // 로딩 끝
    }
  }
}