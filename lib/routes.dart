import 'package:base_clean_arch_bloc/src/app/features/auth/presentation/pages/login_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/base/presentation/pages/base_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => BasePage(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const Placeholder()),
          ],
        ),
      ],
    ),
    GoRoute(path: '/', builder: (context, state) => const Placeholder()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  ],
);
