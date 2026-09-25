import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../build_gift/build_gift_screen.dart';
import '../explore/explore_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

/// Central navigation shell housing the 5 core tabs:
/// Home, Explore, Build (prominent), Favorites, Profile.
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    BuildGiftScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: AppStrings.navHome,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore_rounded,
                  label: AppStrings.navExplore,
                ),
                _buildProminentBuildButton(),
                _buildNavItem(
                  index: 3,
                  icon: Icons.favorite_outline_rounded,
                  selectedIcon: Icons.favorite_rounded,
                  label: AppStrings.navFavorites,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: AppStrings.navProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 22,
              color: isSelected ? AppColors.primary : AppColors.secondaryText,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
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

  /// Visually prominent center "Build Box" action button
  Widget _buildProminentBuildButton() {
    final isSelected = _currentIndex == 2;
    return GestureDetector(
      onTap: () => _onTabSelected(2),
      child: Transform.translate(
        offset: const Offset(0, -10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkPrimary : AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3D6D3F67),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.warmCream,
                  width: 2.5,
                ),
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              AppStrings.navBuild,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.darkPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
