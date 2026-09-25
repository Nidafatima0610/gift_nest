import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import 'widgets/onboarding_visual_1.dart';
import 'widgets/onboarding_visual_2.dart';
import 'widgets/onboarding_visual_3.dart';

/// 3-page polished onboarding experience for Gift Nest.
/// Uses SharedPreferences with key "onboarding_completed".
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const String _onboardingKey = 'onboarding_completed';

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      title: "Find a gift they'll love",
      description:
          "Tell us who you're gifting and what the occasion is. We'll help you discover thoughtful gift ideas.",
      visual: OnboardingVisual1(),
    ),
    OnboardingPageData(
      title: "Make it personal",
      description:
          "Add a name, photo, message, or special touch to make your gift truly theirs.",
      visual: OnboardingVisual2(),
    ),
    OnboardingPageData(
      title: "Build your perfect gift",
      description:
          "Mix and match products from local creators and create a gift box made just for them.",
      visual: OnboardingVisual3(),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onBackPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Back and Skip)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (hidden on first page)
                  if (_currentPage > 0)
                    IconButton(
                      key: const Key('onboarding_back_button'),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.darkPrimary,
                      ),
                      onPressed: _onBackPressed,
                      tooltip: 'Back',
                    )
                  else
                    const SizedBox(width: 44, height: 44),

                  // Subtle Skip Option
                  TextButton(
                    onPressed: _completeOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.secondaryText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md,
                        vertical: AppDimensions.xs,
                      ),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3-Page Horizontal Swiper
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.md),

                        // Bespoke Illustration Visual
                        page.visual,

                        const SizedBox(height: AppDimensions.xl),

                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkPrimary,
                                height: 1.3,
                              ),
                        ),

                        const SizedBox(height: AppDimensions.sm),

                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.sm,
                          ),
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.secondaryText,
                                  height: 1.55,
                                ),
                          ),
                        ),

                        const SizedBox(height: AppDimensions.lg),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Area (Indicators & Button)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                0,
                AppDimensions.lg,
                AppDimensions.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 7,
                        width: _currentPage == index ? 24 : 7,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // Primary Action Button ("Continue" or "Get Started")
                  AppButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    onPressed: _onNextPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class holding text and visual for each onboarding page.
class OnboardingPageData {
  final String title;
  final String description;
  final Widget visual;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.visual,
  });
}
