import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/section_title.dart';
import '../../../models/creator_model.dart';
import '../data/home_demo_data.dart';

/// Section showcasing local artisanal makers and studios.
class LocalCreatorsSection extends StatelessWidget {
  const LocalCreatorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'From Local Creators',
          subtitle: 'Discover something handmade and meaningful',
          actionText: 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.explore),
        ),
        const SizedBox(height: AppDimensions.xs),
        SizedBox(
          height: 164,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: HomeDemoData.creators.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
            itemBuilder: (context, index) {
              final creator = HomeDemoData.creators[index];
              return _CreatorCardItem(creator: creator);
            },
          ),
        ),
      ],
    );
  }
}

class _CreatorCardItem extends StatelessWidget {
  final CreatorModel creator;

  const _CreatorCardItem({required this.creator});

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.isNotEmpty ? name[0] : 'C';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('creator_${creator.id}'),
      onTap: () => Navigator.pushNamed(context, AppRoutes.explore),
      child: Container(
        width: 156,
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Creator Avatar / Logo
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.warmCream,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.softRose, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(creator.name),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                if (creator.isVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Creator / Studio Name
            Text(
              creator.studioName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkPrimary,
              ),
            ),

            const SizedBox(height: 2),

            // City / Location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 12,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    creator.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Small Product / Category Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.softRoseLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${creator.totalProducts} gifts',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
