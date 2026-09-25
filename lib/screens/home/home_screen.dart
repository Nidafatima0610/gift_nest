import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'widgets/build_gift_promo_card.dart';
import 'widgets/home_bottom_nav_bar.dart';
import 'widgets/home_header.dart';
import 'widgets/home_hero_card.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/local_creators_section.dart';
import 'widgets/occasion_section.dart';
import 'widgets/trending_gifts_section.dart';

/// Complete polished Home screen for Gift Nest.
/// Communicates: "Gift Nest helps me find the right gift for the right person."
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Retain AppBar in tree to preserve route testing and accessibility
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          title: const Text('Home'),
          elevation: 0,
          backgroundColor: AppColors.background,
        ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(currentIndex: 0),
      body: const SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header with Greeting, Notification, and Profile Avatar
              HomeHeader(),

              // 2. Prominent Rounded Search Field
              HomeSearchBar(),

              SizedBox(height: AppDimensions.sm),

              // 3. Hero Card: "Don't know what to gift?" -> /gift-finder
              HomeHeroCard(),

              SizedBox(height: AppDimensions.md),

              // 4. Shop by Occasion: Horizontally scrollable occasion cards
              OccasionSection(),

              SizedBox(height: AppDimensions.md),

              // 5. Trending Gifts: Horizontal local demo product cards -> /product-details
              TrendingGiftsSection(),

              SizedBox(height: AppDimensions.sm),

              // 6. Promotional Banner: "Build My Gift" -> /build-gift
              BuildGiftPromoCard(),

              SizedBox(height: AppDimensions.sm),

              // 7. From Local Creators: Horizontal artisan maker cards
              LocalCreatorsSection(),

              SizedBox(height: AppDimensions.xl),
            ],
          ),
        ),
      ),
    );
  }
}
