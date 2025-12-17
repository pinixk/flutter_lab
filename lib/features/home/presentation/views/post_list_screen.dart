import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_view_model.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('무한 스크롤 게시판')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            // 바닥에 닿기 200px 전이면 다음 페이지 로드
            if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
              ref.read(postViewModelProvider.notifier).loadMore();
            }
          }
          return false;
        },
        child: asyncPosts.when(
          data: (posts) {
            return RefreshIndicator(
              onRefresh: () async {
                return ref.invalidate(postViewModelProvider);
              },
              child: ListView.builder(
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),
                      title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  );
                },
              ),
            );
          },
          error: (err, stack) => Center(child: Text('에러: $err')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}