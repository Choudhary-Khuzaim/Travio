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
      'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=2021&auto=format&fit=crop',
      'title': 'Discover\nWorld with us.',
      'subtitle': 'Explore the best places in the world and capture your best moments with us.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=2070&auto=format&fit=crop',
      'title': 'Book Your\nDream Flight',
      'subtitle': 'Find the best deals on flights to your favorite destinations instantly.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=2073&auto=format&fit=crop',
      'title': 'Enjoy Your\nBest Vacation',
      'subtitle': 'Relax and enjoy your holiday with our premium travel packages.',
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
                  image: NetworkImage(_slides[_currentPage]['image']!),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
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
                      return _buildSlideCard(_slides[index], index == _currentPage);
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
                         transitionBuilder: (Widget child, Animation<double> animation) {
                           return FadeTransition(opacity: animation, child: SlideTransition(position: Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(animation), child: child));
                         },
                         child: Column(
                           key: ValueKey<int>(_currentPage),
                           children: [
                              Text(
                                _slides[_currentPage]['title']!.replaceAll('\n', ' '),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      margin: EdgeInsets.symmetric(
        horizontal: 20, 
        vertical: isActive ? 0 : 30 // Scale effect
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          slide['image']!,
          fit: BoxFit.cover,
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
                    : Colors.white.withOpacity(0.3),
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
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _currentPage == _slides.length - 1 ? Icons.check : Icons.arrow_forward,
              color: AppColors.primary,
              size: 28,
            ),
          ).animate(target: _currentPage == _slides.length - 1 ? 1 : 0)
           .scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: 200.ms),
        ),
      ],
    );
  }
}
