import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  // 파란색 성공 스낵바
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating, // 떠있는 스타일
      ),
    );
  }

  // 빨간색 에러 스낵바
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}