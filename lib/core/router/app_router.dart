import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/detail_screen.dart';
import '../../presentation/screens/favorites_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/main_shell.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (ctx, _) => const HomeScreen()),
          GoRoute(path: '/search', builder: (ctx, _) => const SearchScreen()),
          GoRoute(path: '/favorites', builder: (ctx, _) => const FavoritesScreen()),
          GoRoute(path: '/profile', builder: (ctx, _) => const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/movie/:id',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DetailScreen(movieId: id);
        },
      ),
    ],
  );
}