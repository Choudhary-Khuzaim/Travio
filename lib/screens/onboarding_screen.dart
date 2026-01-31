import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:travio/screens/login_screen.dart';
import '../core/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/hunza_onboarding.png',
      'title': 'Discover\nHunza Valley',
      'subtitle':
          'Explore the majestic mountains and breathtaking landscapes of Hunza Valley.',
    },
    {
      'image': 'assets/images/islamabad_onboarding.png',
      'title': 'Book Your\nDream Flight',
      'subtitle':
          'Find the best deals on flights to Islamabad and your favorite destinations.',
    },
    {
      'image': 'assets/images/quetta_onboarding.png',
      'title': 'Enjoy Your\nBest Vacation',
      'subtitle':
          'Relax and enjoy your holiday with our premium travel packages in Quetta.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Blurred Background
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<int>(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_slides[_currentPage]['image']!),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  isAntiAlias: true,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.4)),
              ),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 1),
                // Card Carousel
                SizedBox(
                  height: 480,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildSlideCard(
                        _slides[index],
                        index == _currentPage,
                      );
                    },
                  ),
                ),

                const Spacer(flex: 1),

                // Content & Controls
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                        child: Column(
                          key: ValueKey<int>(_currentPage),
                          children: [
                            Text(
                              _slides[_currentPage]['title']!.replaceAll(
                                '\n',
                                ' ',
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _slides[_currentPage]['subtitle']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildControls(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideCard(Map<String, String> slide, bool isActive) {
    return AnimatedScale(
      scale: isActive ? 1.0 : 0.85,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 25,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            slide['image']!,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            isAntiAlias: true,
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Page Indicators
        Row(
          children: List.generate(
            _slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 8),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.secondary
                    : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        // Next Button
        GestureDetector(
          onTap: () {
            if (_currentPage < _slides.length - 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                ),
              );
            }
          },
          child:
              Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _currentPage == _slides.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  )
                  .animate(target: _currentPage == _slides.length - 1 ? 1 : 0)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 200.ms,
                  ),
        ),
      ],
    );
  }
}
