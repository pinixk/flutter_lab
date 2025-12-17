import 'package:flutter_lab/features/home/data/models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> fetchPosts({required int page, int limit = 10});
}
