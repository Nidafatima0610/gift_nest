import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/product_model.dart';
import '../../../services/gift_recommendation_service.dart';
import '../../explore/widgets/product_grid_card.dart';

/// Complete Results screen widget for Gift Finder.
/// Displays dynamic subtitle, exact/partial match status, 2-column product grid,
/// and 'Change Answers' & 'Start Over' actions.
class GiftResultsGrid extends StatelessWidget {
  final GiftRecommendationResult result;
  final VoidCallback onChangeAnswers;
  final VoidCallback onStartOver;
  final ValueChanged<ProductModel>? onProductTap;

  const GiftResultsGrid({
    super.key,
    required this.result,
    required this.onChangeAnswers,
    required this.onStartOver,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final products = result.products;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Title
          const Text(
            'Gift ideas for them ✨',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.darkPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Dynamic Subtitle reflecting selections
          if (result.summarySubtitle.isNotEmpty) ...[
            Text(
              result.summarySubtitle,
              key: const Key('gift_finder_results_subtitle'),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Low match / Partial match notice if no exact match found
          if (!result.isExactMatch) ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: AppColors.softRose.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "We couldn't find an exact match.",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Here are some ideas you might still love based on their style.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.5,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Section Header: "We found these for you" + Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'We found these for you',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${products.length} ideas',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2-Column Recommendation Product Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.64,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductGridCard(
                product: product,
                onTap: onProductTap != null
                    ? () => onProductTap!(product)
                    : () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetails,
                          arguments: product,
                        );
                      },
              );
            },
          ),

          const SizedBox(height: 24),

          // Bottom Actions: Change Answers & Start Over
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('gift_finder_change_answers_button'),
                  onPressed: onChangeAnswers,
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: const Text(
                    'Change Answers',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton.icon(
                  key: const Key('gift_finder_start_over_button'),
                  onPressed: onStartOver,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text(
                    'Start Over',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryText,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
