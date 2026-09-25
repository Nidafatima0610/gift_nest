import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';

/// Polished full-screen splash screen for Gift Nest with subtle fade and scale animation.
/// Uses SharedPreferences to check if onboarding has been completed.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  static const String _onboardingKey = 'onboarding_completed';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
    _startNavigationTimer();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(milliseconds: 1800), () async {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      final bool isCompleted = prefs.getBool(_onboardingKey) ?? false;

      if (!mounted) return;

      if (isCompleted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tasteful Brand Icon Container
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.softRose.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ribbon detail
                        Container(
                          width: 14,
                          height: double.infinity,
                          color: AppColors.softRose.withValues(alpha: 0.4),
                        ),
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: AppColors.softRose.withValues(alpha: 0.4),
                        ),
                        const Icon(
                          Icons.card_giftcard_rounded,
                          size: 46,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  // Brand Name
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkPrimary,
                          fontSize: 32,
                          letterSpacing: 0.5,
                        ),
                  ),

                  const SizedBox(height: AppDimensions.xs),

                  // Tagline
                  const Text(
                    'Thoughtful gifts, made personal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xxl),

                  // Subtle soft-rose accent loading indicator
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.softRose),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
