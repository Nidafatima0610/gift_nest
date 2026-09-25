import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../models/product_model.dart';
import '../home/widgets/home_bottom_nav_bar.dart';
import 'data/explore_demo_data.dart';
import 'widgets/category_selector.dart';
import 'widgets/explore_empty_state.dart';
import 'widgets/explore_search_bar.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/filter_sort_bar.dart';
import 'widgets/product_grid_card.dart';
import 'widgets/sort_bottom_sheet.dart';

/// Complete, polished Explore & Shop discovery screen for Gift Nest.
class ExploreScreen extends StatefulWidget {
  final String? initialCategory;

  const ExploreScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  late String _selectedCategory;
  final Set<String> _selectedPrices = {};
  final Set<String> _selectedGiftTypes = {};
  final Set<String> _selectedRecipients = {};
  ExploreSortOption _selectedSort = ExploreSortOption.recommended;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? ExploreCategories.all;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _activeFilterCount =>
      _selectedPrices.length + _selectedGiftTypes.length + _selectedRecipients.length;

  /// Filters and sorts catalog products according to user selection.
  List<ProductModel> get _filteredAndSortedProducts {
    List<ProductModel> list = List.from(ExploreDemoData.catalogProducts);

    // 1. Category Filter
    if (_selectedCategory != ExploreCategories.all) {
      final cat = _selectedCategory.toLowerCase();
      list = list.where((p) {
        final inTitle = p.title.toLowerCase().contains(cat);
        final inCategory = p.categoryId.toLowerCase().contains(cat);
        final inOccasions = p.occasions.any((o) => o.toLowerCase().contains(cat));
        final inInterests = p.interests.any((i) => i.toLowerCase().contains(cat));
        final inRecipients = p.recipients.any((r) => r.toLowerCase().contains(cat));

        if (cat == 'handmade') {
          return p.interests.contains('Handmade') ||
              p.occasions.contains('Handmade') ||
              p.title.toLowerCase().contains('handmade') ||
              !p.isCustomizable;
        }

        return inTitle || inCategory || inOccasions || inInterests || inRecipients;
      }).toList();
    }

    // 2. Search Query Filter
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((p) {
        final titleMatch = p.title.toLowerCase().contains(query);
        final creatorMatch = (p.creatorName ?? '').toLowerCase().contains(query);
        final categoryMatch = p.categoryId.toLowerCase().contains(query);
        final occasionMatch = p.occasions.any((o) => o.toLowerCase().contains(query));
        final interestMatch = p.interests.any((i) => i.toLowerCase().contains(query));
        return titleMatch || creatorMatch || categoryMatch || occasionMatch || interestMatch;
      }).toList();
    }

    // 3. Price Filter
    if (_selectedPrices.isNotEmpty) {
      list = list.where((p) {
        return _selectedPrices.any((label) {
          final range = ExploreDemoData.priceRanges.firstWhere(
            (r) => r.label == label,
            orElse: () => const PriceFilterOption(label: ''),
          );
          return range.matches(p.price);
        });
      }).toList();
    }

    // 4. Gift Type Filter
    if (_selectedGiftTypes.isNotEmpty) {
      list = list.where((p) {
        return _selectedGiftTypes.any((type) {
          if (type == 'Personalized') {
            return p.isCustomizable || p.interests.contains('Personalized');
          }
          if (type == 'Handmade') {
            return p.interests.contains('Handmade') ||
                p.occasions.contains('Handmade') ||
                p.title.toLowerCase().contains('handmade');
          }
          if (type == 'Gift Box') {
            return p.interests.contains('Gift Box') ||
                p.title.contains('Box') ||
                p.title.contains('Hamper') ||
                p.categoryId == 'care_packages';
          }
          return false;
        });
      }).toList();
    }

    // 5. Recipient Filter
    if (_selectedRecipients.isNotEmpty) {
      list = list.where((p) {
        return _selectedRecipients.any((recipient) {
          return p.recipients.any((r) => r.toLowerCase() == recipient.toLowerCase());
        });
      }).toList();
    }

    // 6. Sorting
    switch (_selectedSort) {
      case ExploreSortOption.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ExploreSortOption.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ExploreSortOption.newest:
        list.sort((a, b) => (b.createdAt ?? DateTime(2020)).compareTo(a.createdAt ?? DateTime(2020)));
        break;
      case ExploreSortOption.recommended:
        // Preserves curated boutique order
        break;
    }

    return list;
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterBottomSheet(
          initialSelectedPrices: _selectedPrices,
          initialSelectedGiftTypes: _selectedGiftTypes,
          initialSelectedRecipients: _selectedRecipients,
          onApply: (prices, types, recipients) {
            setState(() {
              _selectedPrices
                ..clear()
                ..addAll(prices);
              _selectedGiftTypes
                ..clear()
                ..addAll(types);
              _selectedRecipients
                ..clear()
                ..addAll(recipients);
            });
          },
        );
      },
    );
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SortBottomSheet(
          selectedSort: _selectedSort,
          onSelectSort: (option) {
            setState(() {
              _selectedSort = option;
            });
          },
        );
      },
    );
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = ExploreCategories.all;
      _selectedPrices.clear();
      _selectedGiftTypes.clear();
      _selectedRecipients.clear();
      _selectedSort = ExploreSortOption.recommended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredAndSortedProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            tooltip: 'Cart',
          ),
        ],
      ),
      bottomNavigationBar: const HomeBottomNavBar(currentIndex: 1),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Subtitle & Search
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find something special',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ExploreSearchBar(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    onClear: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Horizontal Categories Selector
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (cat) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            ),

            const SizedBox(height: 10),

            // Filter & Sort Row
            FilterSortBar(
              activeFilterCount: _activeFilterCount,
              selectedSort: _selectedSort,
              totalProductCount: products.length,
              onOpenFilter: _openFilterSheet,
              onOpenSort: _openSortSheet,
            ),

            const SizedBox(height: 10),

            // Product Grid or Empty State
            Expanded(
              child: products.isEmpty
                  ? ExploreEmptyState(
                      title: 'Nothing found',
                      message: _searchQuery.isNotEmpty
                          ? 'No gifts match "$_searchQuery". Try another search or clear filters.'
                          : 'No gifts match your selected filters. Try broadening your criteria.',
                      onReset: _resetAllFilters,
                      resetLabel: 'Reset Filters',
                    )
                  : GridView.builder(
                      key: const Key('explore_products_grid'),
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.lg,
                        2,
                        AppDimensions.lg,
                        AppDimensions.lg,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductGridCard(
                          product: products[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
