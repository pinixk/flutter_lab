import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child; // 여기가 '홈' 또는 '상세' 화면이 들어올 자리입니다.

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [핵심] 껍데기 안의 내용물 (여기가 바뀝니다)
      body: child,

      // [핵심] 껍데기의 하단바 (여기는 고정입니다)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.person), label: '상세정보'),
          NavigationDestination(icon: Icon(Icons.list), label: '게시판'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/detail')) return 1;
    if (location.startsWith('/post')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home'); // go를 사용해야 히스토리 관리가 깔끔합니다.
        break;
      case 1:
        context.go('/detail');
        break;
      case 2:
        context.go('/post');
        break;
    }
  }
}