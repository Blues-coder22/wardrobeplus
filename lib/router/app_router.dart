import 'package:flutter/material.dart';
import '../core/constants/route_constants.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/gender_screen.dart';
import '../screens/onboarding/body_type_quiz_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/main/main_shell.dart';
import '../screens/main/style_preferences_screen.dart';
import '../screens/premium/premium_upgrade_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _fade(const SplashScreen());

      case Routes.onboarding:
        return _slide(const OnboardingScreen());

      case Routes.gender:
        return _slide(const GenderScreen());

      case Routes.bodyQuiz:
        return _slide(const BodyTypeQuizScreen());
        
      case Routes.styleSelector:
        return _slide(StylePreferencesScreen(onBack: () {}));

      case Routes.login:
        return _fade(const LoginScreen());

      case Routes.register:
        return _slide(const RegisterScreen());

      case Routes.forgotPassword:
        return _slide(const ForgotPasswordScreen());

      case Routes.home:
        return _fade(const MainShell());

      case Routes.premium:
        return _modal(const PremiumUpgradeScreen());

      default:
        return _fade(_NotFoundScreen(route: settings.name));
    }
  }

  static PageRoute _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  static PageRoute _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: anim.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRoute _modal(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: anim.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 450),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  final String? route;
  const _NotFoundScreen({this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800)),
            Text('Route "${route ?? ''}" not found',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, Routes.home, (_) => false),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
