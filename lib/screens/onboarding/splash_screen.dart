import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travio/core/colors.dart';
import 'package:travio/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, animation, secondaryAnimation) => 
                const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Parallax effect
          Image.asset(
            'assets/images/hunza_onboarding.png',
            fit: BoxFit.cover,
          )
          .animate()
          .scale(
            begin: const Offset(1.1, 1.1), 
            end: const Offset(1.0, 1.0), 
            duration: 5.seconds, 
            curve: Curves.easeOutCubic
          ),

          // Gradient Overlay to ensure text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.7),
                  AppColors.primary.withOpacity(0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                
                // Glassmorphic Logo Container
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.airplanemode_active_rounded,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .animate()
                .fade(duration: 1.seconds)
                .scale(delay: 300.ms, duration: 800.ms, curve: Curves.easeOutBack)
                .shimmer(delay: 1.2.seconds, duration: 1.5.seconds, color: Colors.white.withOpacity(0.5)),
                
                const SizedBox(height: 32),
                
                // App Name
                Text(
                  'TRAVIO',
                  style: GoogleFonts.outfit(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 8,
                    height: 1.0,
                  ),
                )
                .animate()
                .fade(delay: 600.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack),
                
                const SizedBox(height: 16),
                
                // Tagline with elegant styling
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 40,
                      color: AppColors.accent.withOpacity(0.8),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'PREMIUM JOURNEYS',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 1,
                      width: 40,
                      color: AppColors.accent.withOpacity(0.8),
                    ),
                  ],
                )
                .animate()
                .fade(delay: 1.seconds, duration: 800.ms)
                .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
                
                const Spacer(flex: 4),
                
                // Loading Indicator with "Please wait" text
                Column(
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                        strokeWidth: 2.5,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Preparing your experience...',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                )
                .animate()
                .fade(delay: 1.5.seconds, duration: 1.seconds),
                
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
