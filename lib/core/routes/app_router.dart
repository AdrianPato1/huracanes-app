import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/main_shell.dart';
import '../../presentation/screens/alert_detail/alert_detail_screen.dart';
import '../../presentation/screens/bienvenida/bienvenida_screen.dart';
import '../../presentation/screens/permissions/permissions_screen.dart';
import '../../presentation/screens/refugios/pantalla_mapa.dart';
import '../../presentation/screens/splash/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, _) => const BienvenidaScreen(),
      ),
      GoRoute(
        path: '/permissions',
        name: 'permissions',
        builder: (_, _) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (_, _) => const MainShell(),
      ),
      GoRoute(
        path: '/alert-detail',
        name: 'alert-detail',
        builder: (_, _) => const AlertDetailScreen(),
      ),
      GoRoute(
        path: '/mapa',
        name: 'mapa',
        builder: (_, _) => const PantallaMapa(),
      ),
    ],
  );

  static void goToHome(BuildContext context) {
    if (!context.mounted) return;
    context.go('/main');
  }

  static void goToPermissions(BuildContext context) {
    if (!context.mounted) return;
    context.go('/permissions');
  }

  static void goToOnboarding(BuildContext context) {
    if (!context.mounted) return;
    context.go('/onboarding');
  }

  static void goToMap(BuildContext context) {
    if (!context.mounted) return;
    context.push('/mapa');
  }

  static void goToAlertDetail(BuildContext context) {
    if (!context.mounted) return;
    context.push('/alert-detail');
  }
}
