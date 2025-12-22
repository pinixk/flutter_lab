import 'dart:io';

abstract class ImageRepository {
  // 갤러리에서 사진을 가져와서 File 객체로 반환해줘!
  Future<File?> pickImageFromGallery();
}