import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';

/// Boutique 5-tab bottom navigation bar for Gift Nest.
/// Index 0 (Home) is selected, and Center (Build) is visually prominent.
class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const HomeBottomNavBar({
    super.key,
    this.currentIndex = 0,
  });

  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.explore);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.buildGift);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.favorites);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Tab 0: Home
              _buildNavItem(
                context,
                index: 0,
                key: const Key('nav_tab_home'),
                icon: Icons.home_rounded,
                inactiveIcon: Icons.home_outlined,
                label: 'Home',
              ),

              // Tab 1: Explore
              _buildNavItem(
                context,
                index: 1,
                key: const Key('nav_tab_explore'),
                icon: Icons.explore_rounded,
                inactiveIcon: Icons.explore_outlined,
                label: 'Explore',
              ),

              // Tab 2: Build (Center prominent button)
              _buildCenterBuildItem(context),

              // Tab 3: Favorites
              _buildNavItem(
                context,
                index: 3,
                key: const Key('nav_tab_favorites'),
                icon: Icons.favorite_rounded,
                inactiveIcon: Icons.favorite_outline_rounded,
                label: 'Favorites',
              ),

              // Tab 4: Profile
              _buildNavItem(
                context,
                index: 4,
                key: const Key('nav_tab_profile'),
                icon: Icons.person_rounded,
                inactiveIcon: Icons.person_outline_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required Key key,
    required IconData icon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: InkWell(
        key: key,
        onTap: () => _onTabTapped(context, index),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? icon : inactiveIcon,
              size: 22,
              color: isSelected ? AppColors.primary : AppColors.secondaryText,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterBuildItem(BuildContext context) {
    final isSelected = currentIndex == 2;

    return Expanded(
      child: GestureDetector(
        key: const Key('nav_tab_build'),
        onTap: () => _onTabTapped(context, 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkPrimary : AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Build',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
