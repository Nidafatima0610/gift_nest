import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/explore_demo_data.dart';

/// Bottom sheet allowing users to filter products by Price, Gift Type, and Recipient.
class FilterBottomSheet extends StatefulWidget {
  final Set<String> initialSelectedPrices;
  final Set<String> initialSelectedGiftTypes;
  final Set<String> initialSelectedRecipients;
  final void Function(
    Set<String> selectedPrices,
    Set<String> selectedGiftTypes,
    Set<String> selectedRecipients,
  ) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialSelectedPrices,
    required this.initialSelectedGiftTypes,
    required this.initialSelectedRecipients,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> _selectedPrices;
  late Set<String> _selectedGiftTypes;
  late Set<String> _selectedRecipients;

  @override
  void initState() {
    super.initState();
    _selectedPrices = Set.from(widget.initialSelectedPrices);
    _selectedGiftTypes = Set.from(widget.initialSelectedGiftTypes);
    _selectedRecipients = Set.from(widget.initialSelectedRecipients);
  }

  void _clearAll() {
    setState(() {
      _selectedPrices.clear();
      _selectedGiftTypes.clear();
      _selectedRecipients.clear();
    });
  }

  void _apply() {
    widget.onApply(_selectedPrices, _selectedGiftTypes, _selectedRecipients);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final activeCount =
        _selectedPrices.length + _selectedGiftTypes.length + _selectedRecipients.length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filter Gifts',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkPrimary,
                        ),
                      ),
                      if (activeCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.softRoseLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$activeCount active',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  TextButton(
                    key: const Key('filter_clear_all_button'),
                    onPressed: activeCount > 0 ? _clearAll : null,
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: activeCount > 0
                            ? AppColors.primary
                            : AppColors.secondaryText.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.border),

            // Scrollable Filter Sections
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Price Section
                    _buildSectionHeader('Price', Icons.payments_outlined),
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ExploreDemoData.priceRanges.map((option) {
                        final isSelected = _selectedPrices.contains(option.label);
                        return _buildFilterChip(
                          keyPrefix: 'price',
                          label: option.label,
                          isSelected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedPrices.add(option.label);
                              } else {
                                _selectedPrices.remove(option.label);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppDimensions.xl),

                    // 2. Gift Type Section
                    _buildSectionHeader('Gift Type', Icons.card_giftcard_rounded),
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ExploreDemoData.giftTypes.map((type) {
                        final isSelected = _selectedGiftTypes.contains(type);
                        return _buildFilterChip(
                          keyPrefix: 'type',
                          label: type,
                          isSelected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedGiftTypes.add(type);
                              } else {
                                _selectedGiftTypes.remove(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppDimensions.xl),

                    // 3. Recipient Section
                    _buildSectionHeader('Recipient', Icons.people_outline_rounded),
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ExploreDemoData.recipients.map((recipient) {
                        final isSelected = _selectedRecipients.contains(recipient);
                        return _buildFilterChip(
                          keyPrefix: 'recipient',
                          label: recipient,
                          isSelected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedRecipients.add(recipient);
                              } else {
                                _selectedRecipients.remove(recipient);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppDimensions.md),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: AppColors.border),

            // Bottom Action Bar
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: ElevatedButton(
                key: const Key('filter_apply_button'),
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.warmCream,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: Text(
                  activeCount > 0 ? 'Apply ($activeCount Filters)' : 'Apply Filters',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String keyPrefix,
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    final sanitizedKey = '${keyPrefix}_${label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
    return FilterChip(
      key: Key('chip_$sanitizedKey'),
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: isSelected,
      checkmarkColor: AppColors.warmCream,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? AppColors.warmCream : AppColors.text,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}
