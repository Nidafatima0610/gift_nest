import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/section_title.dart';
import '../data/home_demo_data.dart';

/// Horizontally scrollable "Shop by Occasion" section.
class OccasionSection extends StatelessWidget {
  const OccasionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Shop by Occasion',
          subtitle: 'Discover gifts tailored to every milestone',
          actionText: 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.explore),
        ),
        const SizedBox(height: AppDimensions.xs),
        SizedBox(
          height: 104,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: HomeDemoData.occasions.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
            itemBuilder: (context, index) {
              final occasion = HomeDemoData.occasions[index];
              return _OccasionCard(occasion: occasion);
            },
          ),
        ),
      ],
    );
  }
}

class _OccasionCard extends StatelessWidget {
  final OccasionItem occasion;

  const _OccasionCard({required this.occasion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('occasion_${occasion.id}'),
      onTap: () => Navigator.pushNamed(context, AppRoutes.explore),
      child: Container(
        width: 86,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.xs,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji & Icon Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: occasion.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  occasion.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Occasion Name
            Text(
              occasion.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.mainText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
