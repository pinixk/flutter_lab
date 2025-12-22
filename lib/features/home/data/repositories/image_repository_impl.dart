import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/image_repository.dart';

part 'image_repository_impl.g.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImagePicker _picker;

  ImageRepositoryImpl(this._picker);

  @override
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // 용량 최적화
    );

    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }
}

// [Provider] ImagePicker 객체도 의존성 주입으로 넣어줍니다.
@riverpod
ImageRepository imageRepository(ImageRepositoryRef ref) {
  return ImageRepositoryImpl(ImagePicker());
}