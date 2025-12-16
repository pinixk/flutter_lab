import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/presentation/views/home_screen.dart';
import '../../features/home/presentation/views/detail_screen.dart';
import '../layout/main_layout.dart'; // 위에서 만든 Layout import

part 'router_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // [핵심 구조]
      // ShellRoute(껍데기) 안에 routes(내용물들)를 넣습니다.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        // 껍데기 위젯 빌드
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        // 이 안에 있는 화면들은 전부 하단 바를 가집니다.
        routes: [
          // 1번 탭: 홈
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          // 2번 탭: 상세 (여기도 하단 바가 유지됩니다!)
          GoRoute(
            path: '/detail',
            name: 'detail',
            builder: (context, state) => const DetailScreen(),
          ),
        ],
      ),
    ],
  );
}