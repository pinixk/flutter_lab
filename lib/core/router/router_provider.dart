import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_view_model.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/splash_screen.dart';
import '../../features/home/presentation/views/home_screen.dart';
import '../../features/home/presentation/views/detail_screen.dart';
import '../../features/home/presentation/views/post_list_screen.dart';
import '../error/not_found_screen.dart';
import '../layout/main_layout.dart';

part 'router_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  // 1. [감시] AuthViewModel의 상태 변화를 계속 지켜봅니다.
  // 로그인/로그아웃 할 때마다 이 routerProvider가 다시 빌드되어 redirect가 실행됩니다.
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',

    // 2. [문지기] 리다이렉트 로직 (가장 중요한 부분!)
    redirect: (context, state) {
      // 현재 앱의 인증 상태 (로딩중 / 로그인됨 / 안됨)
      final authStatus = authState.valueOrNull;

      // 현재 사용자가 가려고 하는 위치
      final String location = state.uri.toString();

      // (1) 아직 토큰 검사 중이라면? -> 스플래시 화면으로 보냄
      if (authState.isLoading || authStatus == AuthStatus.unknown) {
        return '/splash';
      }

      // (2) 로그인 된 상태인가?
      final bool isAuthenticated = authStatus == AuthStatus.authenticated;

      // (3) 지금 로그인 페이지에 있는가?
      final bool isOnLoginPage = location == '/login';
      final bool isOnSplashPage = location == '/splash';

      // [납치 로직 1] 로그인을 안 했는데, 로그인 페이지가 아닌 곳(홈 등)을 가려 한다?
      // -> 로그인 페이지로 강제 이동!
      if (!isAuthenticated && !isOnLoginPage) {
        return '/login';
      }

      // [납치 로직 2] 이미 로그인을 했는데, 로그인 페이지나 스플래시에 있다?
      // -> 홈으로 강제 이동!
      if (isAuthenticated && (isOnLoginPage || isOnSplashPage)) {
        return '/home';
      }

      // 아무 문제 없으면 가려던 곳으로 보냄 (null 리턴)
      return null;
    },

    // ...

    // [New] 에러 빌더 수정
    errorBuilder: (context, state) {
      // state.uri : 사용자가 접속하려던 주소
      // state.error : 발생한 에러 객체
      return NotFoundScreen(
        uri: state.uri.toString(),
        error: state.error,
      );
    },

    routes: [
      // 1. 스플래시 화면
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

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
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/detail',
            name: 'detail',
            builder: (context, state) => const DetailScreen(),
          ),
          // [New] 탭 2: 게시판 (여기에 추가!)
          GoRoute(
            path: '/posts',
            name: 'posts',
            builder: (context, state) => const PostListScreen(),
          ),
        ],
      ),
    ],
  );
}
