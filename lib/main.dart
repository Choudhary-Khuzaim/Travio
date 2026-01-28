import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const TravioApp());
}

class TravioApp extends StatelessWidget {
  const TravioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}
