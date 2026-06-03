import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'package:travio/screens/onboarding/splash_screen.dart';
import 'package:travio/screens/main/home_screen.dart';
import 'package:travio/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
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
      home: ApiService.isLoggedIn ? const HomeScreen() : const SplashScreen(),
    );
  }
}
