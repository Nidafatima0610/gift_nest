import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Photo keepsake selection widget allowing optional photo memory addition to gift box.
class GiftPhotoPicker extends StatelessWidget {
  final String? photoPath;
  final ValueChanged<String?> onPhotoChanged;

  const GiftPhotoPicker({
    super.key,
    required this.photoPath,
    required this.onPhotoChanged,
  });

  static const String demoMemoryPhoto =
      'https://images.unsplash.com/photo-1518895949257-7621c3c786d7?q=80&w=400';

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.softRoseLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            const Expanded(
              child: Text(
                'Add a special memory',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'We will print a mini keepsake photo and tuck it into the box. (Optional)',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),

        // Photo Card / Upload State
        hasPhoto
            ? Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.softRose, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: AppColors.surfaceVariant,
                        child: Image.network(
                          photoPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(
                              Icons.insert_photo_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.success,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Memory Attached',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.mainText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Keepsake Polaroid Print (10×15 cm)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      key: const Key('remove_photo_button'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => onPhotoChanged(null),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      label: const Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('attach_photo_button'),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    onTap: () {
                      onPhotoChanged(demoMemoryPhoto);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.lg,
                        horizontal: AppDimensions.md,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: AppDimensions.sm),
                          Text(
                            'Tap to attach a photo memory',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Printed on archival matte card (Optional)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
