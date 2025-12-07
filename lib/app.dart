import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/profile_setup_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/hackathons/screens/hackathons_screen.dart';
import 'features/hackathons/screens/hackathon_detail_screen.dart';
import 'features/practice/screens/practice_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/team/screens/create_team_request_screen.dart';

class HackMateApp extends StatelessWidget {
  final bool firebaseInitialized;

  const HackMateApp({super.key, required this.firebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HackMate',
      theme: HackMateTheme.lightTheme,
      darkTheme: HackMateTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), // Skip splash for demo
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/hackathons',
      builder: (context, state) => const HackathonsScreen(),
    ),
    GoRoute(
      path: '/hackathon/:id',
      builder: (context, state) => HackathonDetailScreen(
        hackathonId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/practice',
      builder: (context, state) => const PracticeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/create-team',
      builder: (context, state) => const CreateTeamRequestScreen(),
    ),
  ],
);
