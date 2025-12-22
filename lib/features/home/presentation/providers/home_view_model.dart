import 'dart:io';

import 'package:flutter_lab/features/home/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/image_repository.dart'; // 인터페이스 사용
import '../../data/repositories/image_repository_impl.dart'; // Provider 사용

part 'home_view_model.freezed.dart'; // [중요] 파일명.freezed.dart 추가
part 'home_view_model.g.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default('데이터 불러오는 중...') String message, // 메시지 상태 (기본값 설정)
    @Default(UserModel(name: '김코딩', age: 25)) UserModel user, // 유저 상태

    File? profileImage,
  }) = _HomeState;
}

// 상태 관리 클래스 (Notifier)
@riverpod
class HomeViewModel extends _$HomeViewModel {
  // 초기 상태(build) 정의
  @override
  Future<HomeState> build() async {
    return const HomeState(
      message: '서버 데이터 로드 완료!',
      user: UserModel(name: '김아무개', age: 25),
    );
  }

  void updateName() async {
    final currentState = state.value;
    if (currentState == null) return;

    final repository = ref.watch(homeRepositoryProvider);
    final user = await repository.fetchUser();

    // 1. 화면을 로딩 상태로 바꿈 (낙관적 업데이트가 아니라면)
    state = const AsyncValue.loading();

    // 2. AsyncValue.guard: 에러 처리를 자동으로 해주는 마법의 도구
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 1));

      return currentState.copyWith(
        user: currentState.user.copyWith(name: user.name),
      );
    });
  }

  void incrementAge() async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(
      currentState.copyWith(
        user: currentState.user.copyWith(age: currentState.user.age + 1),
      ),
    );
  }

  // [Refactoring] 이미지 선택 함수
  Future<void> pickImage() async {
    // 1. Repository 가져오기
    // (이제 ViewModel은 ImagePicker가 뭔지 모릅니다. 그냥 Repository만 알 뿐)
    final imageRepo = ref.read(imageRepositoryProvider);

    // 2. Data Layer에 요청
    final File? imageFile = await imageRepo.pickImageFromGallery();

    // 3. 결과가 있으면 상태 업데이트
    if (imageFile != null) {
      final currentState = state.value;

      if (currentState != null) {
        state = AsyncValue.data(
          currentState.copyWith(profileImage: imageFile),
        );
      }
    }
  }

  // [New] 업로드 함수
  Future<void> uploadImage() async {
    final currentState = state.value;

    // 1. 선택된 이미지가 없으면 업로드 불가
    if (currentState == null || currentState.profileImage == null) {
      print('선택된 이미지가 없습니다.');
      return;
    }

    // 2. 로딩 상태로 변경 (화면 깜빡임 방지 위해 AsyncValue.guard 사용 권장)
    // 하지만 여기서는 "기존 화면 유지하면서 로딩바만 띄우기" 위해 state를 직접 바꾸지 않고
    // 별도의 isLoading 필드를 두거나, UI에서 처리하기도 합니다.
    // 여기서는 간단히 전체 로딩으로 처리하겠습니다.
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // 3. Repository 호출
      final homeRepo = ref.read(homeRepositoryProvider);

      // 업로드 수행
      final updatedUser = await homeRepo.uploadProfileImage(currentState.profileImage!);

      // 4. 업로드 성공 후 상태 갱신
      // (서버에서 받은 최신 유저 정보 + 현재 선택된 이미지는 유지 or 초기화)
      return currentState.copyWith(
        user: updatedUser,
        message: '프로필 사진 업데이트 완료!',
        // 업로드 끝났으니 선택된 파일은 비워줄 수도 있고 남겨둘 수도 있음
        // profileImage: null,
      );
    });
  }
}
