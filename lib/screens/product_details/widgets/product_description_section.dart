import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/product_model.dart';

/// Expandable product description and structured specification details.
class ProductDescriptionSection extends StatefulWidget {
  final ProductModel product;

  const ProductDescriptionSection({
    super.key,
    required this.product,
  });

  @override
  State<ProductDescriptionSection> createState() =>
      _ProductDescriptionSectionState();
}

class _ProductDescriptionSectionState
    extends State<ProductDescriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isHandmade = p.interests.contains('Handmade') ||
        p.occasions.contains('Handmade') ||
        p.categoryId == 'handmade' ||
        p.title.toLowerCase().contains('handmade');

    final details = <MapEntry<String, String>>[];
    if (p.material != null && p.material!.isNotEmpty) {
      details.add(MapEntry('Material', p.material!));
    }
    if (p.size != null && p.size!.isNotEmpty) {
      details.add(MapEntry('Size', p.size!));
    }
    if (p.color != null && p.color!.isNotEmpty) {
      details.add(MapEntry('Color', p.color!));
    }
    if (isHandmade) {
      details.add(const MapEntry('Handmade', 'Yes, crafted in artisan batches'));
    }
    if (p.preparationTime != null && p.preparationTime!.isNotEmpty) {
      details.add(MapEntry('Estimated prep time', p.preparationTime!));
    }

    final hasLongDescription = p.description.length > 120;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: About this gift
          const Text(
            'About this gift',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Description with Read more toggle
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isExpanded || !hasLongDescription
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              p.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.5,
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
            secondChild: Text(
              p.description,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.5,
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
          ),

          if (hasLongDescription) ...[
            const SizedBox(height: 4),
            GestureDetector(
              key: const Key('description_read_more_button'),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Read less' : 'Read more',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],

          if (details.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.lg),
            const Text(
              'Details',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.darkPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(details.length, (index) {
                  final entry = details[index];
                  final isLast = index == details.length - 1;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!isLast)
                        const Divider(
                          height: 16,
                          thickness: 0.8,
                          color: AppColors.border,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
