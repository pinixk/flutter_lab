import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../auth/presentation/providers/auth_view_model.dart';
import '../providers/home_view_model.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<AsyncValue<HomeState>>(homeViewModelProvider, (previous, next) {

      // (1) 에러가 발생했을 때 -> 빨간 스낵바
      if (next.hasError && !next.isLoading) {
        context.showErrorSnackBar('에러 발생: ${next.error}');
      }

      // (2) 로딩이 끝났고, 데이터가 있으며, 특정 메시지가 변경되었을 때 -> 성공 스낵바
      // (여기서는 ViewModel에서 성공 시 message를 '완료!'로 바꿨다고 가정)
      if (next.hasValue && !next.isLoading) {
        final currentMsg = next.value!.message;
        // 이전 메시지와 다를 때만 띄운다 (중복 방지)
        final prevMsg = previous?.value?.message;

        if (currentMsg != prevMsg && currentMsg.contains('완료')) {
          context.showSuccessSnackBar(currentMsg);
        }
      }
    });

    final asyncState = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 페이지'),
        actions: [
          // 저장 버튼 (이미지가 있을 때만 보임)
          asyncState.maybeWhen(
            data: (state) => state.profileImage != null
                ? IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      // 업로드 요청
                      ref.read(homeViewModelProvider.notifier).uploadImage();
                    },
                  )
                : const SizedBox.shrink(), // 이미지 없으면 버튼 숨김
            orElse: () => const SizedBox.shrink(),
          ),

          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 요청 -> 상태가 unauthenticated로 바뀜 -> 라우터가 감지 -> 로그인 화면으로 이동
              ref.read(authViewModelProvider.notifier).logout();
            },
          ),
        ],
      ), // 제목 변경

      body: asyncState.when(
        // 데이터가 있을 때만 보여줌
        data: (state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // 1. 동그란 이미지
                  CircleAvatar(
                    radius: 60, // 크기 60
                    backgroundColor: Colors.grey[300],
                    // 이미지가 있으면 FileImage(로컬), 없으면 아이콘
                    backgroundImage: state.profileImage != null
                        ? FileImage(state.profileImage!)
                        : null,
                    child: state.profileImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),

                  // 2. 카메라 버튼 (오른쪽 아래)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // 갤러리 열기 요청
                        ref.read(homeViewModelProvider.notifier).pickImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                '이름: ${state.user.name}',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                '주소: ${state.user.address}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                '나이: ${state.user.age}세',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        // 로딩이나 에러 처리는 간단하게 (실무에선 공통 위젯 사용)
        error: (err, stack) => Center(child: Text('에러: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
