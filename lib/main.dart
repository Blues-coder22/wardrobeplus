import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'presentation/auth/onboarding_screen.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/registration_screen.dart';
import 'presentation/auth/body_type_quiz_screen.dart';
import 'presentation/navigation/app_navigation_container.dart';
import 'presentation/closet/outfit_details.dart';
import 'presentation/dashboard/trend_details_screen.dart';
import 'presentation/profile/style_preferences_screen.dart';

void main() => runApp(const WardrobePlusApp());

class WardrobePlusApp extends StatefulWidget {
  const WardrobePlusApp({super.key});
  @override
  State<WardrobePlusApp> createState() => _WardrobePlusAppState();
}

class _WardrobePlusAppState extends State<WardrobePlusApp> {
  String activeRouterPath = 'onboarding';
  String dynamicArgumentString = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wardrobe+',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: _resolveUILayoutState(),
    );
  }

  Widget _resolveUILayoutState() {
    if (activeRouterPath.startsWith('closet_detail_')) {
      final title = activeRouterPath.replaceFirst('closet_detail_', '');
      return OutfitDetailsScreen(itemName: title, onBack: () => setState(() => activeRouterPath = 'app_frame'));
    }
    if (activeRouterPath.startsWith('trend_detail_')) {
      final trend = activeRouterPath.replaceFirst('trend_detail_', '');
      return TrendDetailsScreen(trendName: trend, onBack: () => setState(() => activeRouterPath = 'app_frame'));
    }

    switch (activeRouterPath) {
      case 'onboarding':
        return OnboardingScreen(onNext: () => setState(() => activeRouterPath = 'login'));
      case 'login':
        return LoginScreen(onLoginSuccess: () => setState(() => activeRouterPath = 'quiz'), onNavigateToRegister: () => setState(() => activeRouterPath = 'register'));
      case 'register':
        return RegistrationScreen(onRegisterSuccess: () => setState(() => activeRouterPath = 'quiz'));
      case 'quiz':
        return BodyTypeQuizScreen(onComplete: () => setState(() => activeRouterPath = 'app_frame'));
      case 'style_pref':
        return StylePreferencesScreen(onBack: () => setState(() => activeRouterPath = 'app_frame'));
      case 'app_frame':
      default:
        return AppNavigationContainer(
          onSubScreenNavigate: (route) => setState(() => activeRouterPath = route),
          onOpenStylePreference: () => setState(() => activeRouterPath = 'style_pref'),
        );
    }
  }
}