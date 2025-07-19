import 'package:base_clean_arch_bloc/src/app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  ],
);
