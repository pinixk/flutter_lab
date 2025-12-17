import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_provider.dart';
import '../models/post_model.dart';

part 'post_repository_impl.g.dart';

class PostRepositoryImpl {
  final Dio _dio;

  PostRepositoryImpl(this._dio);

  // [핵심] 페이지네이션 요청
  // page: 1페이지, 2페이지...
  // limit: 한 번에 가져올 개수 (보통 10개 or 20개)
  Future<List<PostModel>> fetchPosts({required int page, int limit = 10}) async {
    // API 파라미터 계산 (JSONPlaceholder 기준)
    // 1페이지 -> start 0
    // 2페이지 -> start 10
    final start = (page - 1) * limit;

    final response = await _dio.get(
      '/posts',
      queryParameters: {
        '_start': start,
        '_limit': limit,
      },
    );

    // List<dynamic> -> List<PostModel> 변환
    return (response.data as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }
}

@riverpod
PostRepositoryImpl postRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PostRepositoryImpl(dio);
}