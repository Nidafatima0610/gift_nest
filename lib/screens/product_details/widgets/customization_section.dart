import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/product_model.dart';

/// Flagship customization section supporting Name, Message, Photo upload,
/// Color, Size, and live personalization summary.
class CustomizationSection extends StatefulWidget {
  final ProductModel product;
  final ValueChanged<Map<String, String>> onPersonalizationChanged;
  final VoidCallback? onValidityChanged;

  const CustomizationSection({
    super.key,
    required this.product,
    required this.onPersonalizationChanged,
    this.onValidityChanged,
  });

  @override
  State<CustomizationSection> createState() => _CustomizationSectionState();
}

class _CustomizationSectionState extends State<CustomizationSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _customTextController = TextEditingController();

  String? _selectedColor;
  String? _selectedSize;
  String? _selectedPhotoUrl;

  @override
  void initState() {
    super.initState();
    // Default initial color / size if available
    if (widget.product.availableColors.isNotEmpty) {
      _selectedColor = widget.product.availableColors.first;
    }
    if (widget.product.availableSizes.isNotEmpty) {
      _selectedSize = widget.product.availableSizes.first;
    }

    _nameController.addListener(_notifyChanges);
    _messageController.addListener(_notifyChanges);
    _customTextController.addListener(_notifyChanges);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    _customTextController.dispose();
    super.dispose();
  }

  void _notifyChanges() {
    final map = <String, String>{};
    if (_nameController.text.trim().isNotEmpty) {
      map['Name'] = _nameController.text.trim();
    }
    if (_messageController.text.trim().isNotEmpty) {
      map['Message'] = _messageController.text.trim();
    }
    if (_customTextController.text.trim().isNotEmpty) {
      map['Custom Text'] = _customTextController.text.trim();
    }
    if (_selectedColor != null) {
      map['Color'] = _selectedColor!;
    }
    if (_selectedSize != null) {
      map['Size'] = _selectedSize!;
    }
    if (_selectedPhotoUrl != null) {
      map['Photo'] = 'Selected Photo (${_selectedPhotoUrl!.split('?').first.split('/').last})';
    }

    widget.onPersonalizationChanged(map);
    widget.onValidityChanged?.call();
    setState(() {});
  }

  bool _fieldActive(String keyword) {
    return widget.product.customizableFields.any(
      (f) => f.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  void _choosePhoto() {
    // Simulated device photo selection with preset boutique keepsake photos
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Keepsake Photo',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose a demo portrait or memory to print on this keepsake.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPhotoChoice(
                        key: const Key('photo_option_portrait'),
                        title: 'Portrait',
                        url: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400',
                      ),
                      _buildPhotoChoice(
                        key: const Key('photo_option_couple'),
                        title: 'Couple',
                        url: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?q=80&w=400',
                      ),
                      _buildPhotoChoice(
                        key: const Key('photo_option_family'),
                        title: 'Family',
                        url: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=400',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoChoice({
    required Key key,
    required String title,
    required String url,
  }) {
    return InkWell(
      key: key,
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _selectedPhotoUrl = url;
        });
        _notifyChanges();
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.surfaceVariant,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Center(
                  child: Icon(Icons.photo_rounded, color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.product.isCustomizable) {
      return const SizedBox.shrink();
    }

    final showName = _fieldActive('name');
    final showMessage = _fieldActive('message') || _fieldActive('note');
    final showPhoto = _fieldActive('photo');
    final showCustomText = _fieldActive('text') || _fieldActive('initials');
    final showColor = _fieldActive('color') || widget.product.availableColors.isNotEmpty;
    final showSize = _fieldActive('size') || widget.product.availableSizes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.warmCream.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: AppColors.softRose.withValues(alpha: 0.45),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: AppColors.softRoseLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Make it personal ✨',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkPrimary,
                        ),
                      ),
                      Text(
                        'Add your own special touch.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.md),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppDimensions.sm),

            // 1. Name Field
            if (showName) ...[
              _buildFieldLabel('Name / Recipient', isRequired: true),
              const SizedBox(height: 6),
              TextField(
                key: const Key('customization_name_field'),
                controller: _nameController,
                maxLength: 25,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  color: AppColors.text,
                ),
                decoration: _inputDecoration(
                  hintText: 'Enter a name',
                  prefixIcon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
            ],

            // 2. Custom Text / Initials
            if (showCustomText && !showName) ...[
              _buildFieldLabel('Custom Inscription / Initials', isRequired: true),
              const SizedBox(height: 6),
              TextField(
                key: const Key('customization_text_field'),
                controller: _customTextController,
                maxLength: 35,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  color: AppColors.text,
                ),
                decoration: _inputDecoration(
                  hintText: 'Enter custom text or initials',
                  prefixIcon: Icons.edit_outlined,
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
            ],

            // 3. Message Field
            if (showMessage) ...[
              _buildFieldLabel('Personal Message', isRequired: false),
              const SizedBox(height: 6),
              TextField(
                key: const Key('customization_message_field'),
                controller: _messageController,
                maxLines: 3,
                maxLength: 120,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  color: AppColors.text,
                ),
                decoration: _inputDecoration(
                  hintText: 'Write a personal message...',
                  prefixIcon: Icons.mail_outline_rounded,
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
            ],

            // 4. Photo Upload Field
            if (showPhoto) ...[
              _buildFieldLabel('Photo Upload', isRequired: false),
              const SizedBox(height: 6),
              _buildPhotoUploadCard(),
              const SizedBox(height: AppDimensions.md),
            ],

            // 5. Color Selection
            if (showColor && widget.product.availableColors.isNotEmpty) ...[
              _buildFieldLabel('Choose Color', isRequired: false),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.product.availableColors.map((colorName) {
                  final isSelected = _selectedColor == colorName;
                  return ChoiceChip(
                    key: Key('color_chip_${colorName.toLowerCase().replaceAll(' ', '_')}'),
                    label: Text(colorName),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedColor = colorName;
                        });
                        _notifyChanges();
                      }
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.warmCream : AppColors.darkPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.md),
            ],

            // 6. Size Selection
            if (showSize && widget.product.availableSizes.isNotEmpty) ...[
              _buildFieldLabel('Choose Size', isRequired: false),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.product.availableSizes.map((sizeName) {
                  final isSelected = _selectedSize == sizeName;
                  return ChoiceChip(
                    key: Key('size_chip_${sizeName.toLowerCase().replaceAll(' ', '_')}'),
                    label: Text(sizeName),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedSize = sizeName;
                        });
                        _notifyChanges();
                      }
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.warmCream : AppColors.darkPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.md),
            ],

            // 7. Live Customization Summary Card
            _buildLiveSummaryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkPrimary,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        color: AppColors.secondaryText,
      ),
      filled: true,
      fillColor: AppColors.surface,
      prefixIcon: Icon(prefixIcon, color: AppColors.secondaryText, size: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildPhotoUploadCard() {
    if (_selectedPhotoUrl != null) {
      return Container(
        key: const Key('photo_preview_container'),
        padding: const EdgeInsets.all(AppDimensions.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _selectedPhotoUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.photo_rounded, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Photo attached ✨',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkPrimary,
                    ),
                  ),
                  Text(
                    'Ready for artisan printing',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              key: const Key('replace_photo_button'),
              onPressed: _choosePhoto,
              child: const Text(
                'Replace',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            IconButton(
              key: const Key('remove_photo_button'),
              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.error),
              onPressed: () {
                setState(() {
                  _selectedPhotoUrl = null;
                });
                _notifyChanges();
              },
            ),
          ],
        ),
      );
    }

    return InkWell(
      key: const Key('photo_upload_placeholder'),
      onTap: _choosePhoto,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
            style: BorderStyle.solid,
            width: 1.2,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text(
              'Upload keepsake photo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveSummaryCard() {
    final hasName = _nameController.text.trim().isNotEmpty;
    final hasText = _customTextController.text.trim().isNotEmpty;
    final hasMessage = _messageController.text.trim().isNotEmpty;
    final hasPhoto = _selectedPhotoUrl != null;
    final hasAny = hasName || hasText || hasMessage || hasPhoto || _selectedColor != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.visibility_outlined, size: 15, color: AppColors.primary),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Your personalization',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkPrimary,
                  ),
                ),
              ),
              if (widget.product.personalizationPrice > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.softRoseLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+ PKR ${widget.product.personalizationPrice.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (!hasAny)
            const Text(
              'No custom details added yet. Fill in the options above to preview your gift.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                color: AppColors.secondaryText,
                fontStyle: FontStyle.italic,
              ),
            )
          else ...[
            if (hasName) _buildSummaryLine('Name', _nameController.text.trim()),
            if (hasText) _buildSummaryLine('Inscription', _customTextController.text.trim()),
            if (_selectedColor != null) _buildSummaryLine('Color', _selectedColor!),
            if (_selectedSize != null) _buildSummaryLine('Size', _selectedSize!),
            if (hasPhoto) _buildSummaryLine('Photo', 'Attached for printing'),
            if (hasMessage) _buildSummaryLine('Card Message', _messageController.text.trim()),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.darkPrimary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
