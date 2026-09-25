import '../models/product_model.dart';
import '../screens/explore/data/explore_demo_data.dart';
import '../screens/gift_finder/models/gift_finder_state.dart';

/// Result container returned by [GiftRecommendationService].
class GiftRecommendationResult {
  final List<ProductModel> products;
  final bool isExactMatch;
  final String summarySubtitle;

  const GiftRecommendationResult({
    required this.products,
    required this.isExactMatch,
    required this.summarySubtitle,
  });
}

/// Service implementing rule-based recommendation logic for the Gift Finder.
/// Evaluates recipient, occasion, interest, and budget parameters to rank
/// products deterministically.
class GiftRecommendationService {
  const GiftRecommendationService();

  /// Generates a ranked list of recommended products based on user answers.
  GiftRecommendationResult recommendGifts(
    GiftFinderState state, {
    List<ProductModel>? catalog,
  }) {
    final products = catalog ?? ExploreDemoData.catalogProducts;
    if (products.isEmpty) {
      return GiftRecommendationResult(
        products: const [],
        isExactMatch: false,
        summarySubtitle: state.formattedSubtitle,
      );
    }

    final budgetRange = _parseBudget(state.budget);
    final mappedRecipients = _mapRecipient(state.recipient);

    final scoredItems = <_ScoredProduct>[];

    for (final product in products) {
      double score = 0;
      bool matchedBudget = false;
      bool matchedRecipient = false;
      bool matchedOccasion = false;
      int matchedInterestsCount = 0;

      // 1. Recipient Match
      if (mappedRecipients.isNotEmpty) {
        final productRecipientsLower =
            product.recipients.map((r) => r.toLowerCase()).toSet();
        for (final r in mappedRecipients) {
          if (productRecipientsLower.contains(r.toLowerCase())) {
            matchedRecipient = true;
            score += 30;
            break;
          }
        }
      }

      // 2. Occasion Match
      if (state.occasion != null && state.occasion!.isNotEmpty) {
        final occLower = state.occasion!.toLowerCase();
        final productOccasionsLower =
            product.occasions.map((o) => o.toLowerCase()).toList();

        if (productOccasionsLower.any((o) => o.contains(occLower) || occLower.contains(o))) {
          matchedOccasion = true;
          score += 25;
        } else if (occLower == 'just because' ||
            occLower == 'thank you' ||
            occLower == 'get well') {
          // Broad gifting occasions favor care packages, treats, and keepsake gifts
          if (product.categoryId == 'care_packages' ||
              product.categoryId == 'home_living' ||
              product.categoryId == 'home_fragrance') {
            matchedOccasion = true;
            score += 18;
          }
        }
      }

      // 3. Budget Match
      if (budgetRange != null) {
        final price = product.price;
        if (price >= budgetRange.min && price <= budgetRange.max) {
          matchedBudget = true;
          score += 30;
        } else {
          // Check proximity (within 20% of range)
          final buffer = (budgetRange.max != double.infinity)
              ? (budgetRange.max * 0.20)
              : 2000.0;
          if (price >= (budgetRange.min - buffer) && price <= (budgetRange.max + buffer)) {
            score += 12;
          }
        }
      }

      // 4. Interests Match
      if (state.interests.isNotEmpty) {
        for (final interest in state.interests) {
          if (_matchesInterest(product, interest)) {
            matchedInterestsCount++;
            score += 15;
          }
        }
      }

      // 5. Personalization Bonus (Gift Nest flagship feature)
      if (product.isCustomizable) {
        score += 10;
      }

      // 6. Quality & Rating
      score += (product.rating * 2.0);
      if (product.isPopular) {
        score += 5;
      }

      scoredItems.add(
        _ScoredProduct(
          product: product,
          score: score,
          matchedBudget: matchedBudget,
          matchedRecipient: matchedRecipient,
          matchedOccasion: matchedOccasion,
          matchedInterestsCount: matchedInterestsCount,
        ),
      );
    }

    // Sort descending by score
    scoredItems.sort((a, b) => b.score.compareTo(a.score));

    // Determine if exact match exists
    // An exact match requires budget match AND at least 2 primary criteria matches
    final exactMatches = scoredItems.where((item) {
      final primaryCriteria = (item.matchedRecipient ? 1 : 0) +
          (item.matchedOccasion ? 1 : 0) +
          (item.matchedInterestsCount > 0 ? 1 : 0);
      return item.matchedBudget && primaryCriteria >= 1 && item.score >= 60;
    }).toList();

    final bool isExact = exactMatches.length >= 2;

    // Pick top recommendations (minimum 4 products, up to 8)
    final selectedProducts = scoredItems
        .take(8)
        .map((s) => s.product)
        .toList();

    return GiftRecommendationResult(
      products: selectedProducts,
      isExactMatch: isExact,
      summarySubtitle: state.formattedSubtitle,
    );
  }

  _BudgetRange? _parseBudget(String? budget) {
    if (budget == null) return null;
    final b = budget.toLowerCase();
    if (b.contains('under') || b.contains('< 1,000') || b.contains('1,000') && !b.contains('2,500')) {
      return const _BudgetRange(0, 1000);
    } else if (b.contains('1,000') && b.contains('2,500')) {
      return const _BudgetRange(1000, 2500);
    } else if (b.contains('2,500') && b.contains('5,000')) {
      return const _BudgetRange(2500, 5000);
    } else if (b.contains('5,000') && b.contains('10,000')) {
      return const _BudgetRange(5000, 10000);
    } else if (b.contains('10,000+')) {
      return const _BudgetRange(10000, double.infinity);
    }
    return const _BudgetRange(0, double.infinity);
  }

  List<String> _mapRecipient(String? recipient) {
    if (recipient == null) return const [];
    switch (recipient.toLowerCase()) {
      case 'mom':
        return ['For Her', 'Parents'];
      case 'dad':
        return ['For Him', 'Parents'];
      case 'partner':
        return ['Partner', 'For Her', 'For Him'];
      case 'friend':
        return ['Friends'];
      case 'sister':
        return ['For Her', 'Friends'];
      case 'brother':
        return ['For Him', 'Friends'];
      case 'child':
        return ['Kids'];
      case 'colleague':
        return ['Friends', 'For Him', 'For Her'];
      default:
        return [recipient];
    }
  }

  bool _matchesInterest(ProductModel product, String interest) {
    final i = interest.toLowerCase();
    final title = product.title.toLowerCase();
    final desc = product.description.toLowerCase();
    final cat = product.categoryId.toLowerCase();
    final prodInterests = product.interests.map((x) => x.toLowerCase()).toList();

    if (prodInterests.contains(i)) return true;

    switch (i) {
      case 'fashion':
        return cat == 'accessories' || cat == 'jewelry' || desc.contains('leather');
      case 'beauty':
        return cat == 'care_packages' || desc.contains('scrub') || desc.contains('salts');
      case 'self care':
        return cat == 'care_packages' || cat == 'home_fragrance' || desc.contains('candle');
      case 'home decor':
        return cat == 'home_living' ||
            cat == 'home_fragrance' ||
            cat == 'keepsakes' ||
            title.contains('mug') ||
            title.contains('candle') ||
            title.contains('frame');
      case 'books':
        return cat == 'stationery' || title.contains('journal') || title.contains('scrapbook');
      case 'food & sweets':
        return desc.contains('baklava') || cat == 'care_packages' || desc.contains('hamper');
      case 'jewelry':
        return cat == 'jewelry' || title.contains('bracelet') || title.contains('box');
      case 'stationery':
        return cat == 'stationery' || title.contains('journal') || title.contains('desk');
      case 'tech':
        return title.contains('desk') || desc.contains('dock') || desc.contains('phone');
      case 'handmade':
        return prodInterests.contains('handmade') ||
            desc.contains('handcrafted') ||
            (product.material != null && product.material!.toLowerCase().contains('handmade'));
      case 'cute & kawaii':
        return title.contains('mug') || title.contains('baby') || desc.contains('pastel');
      case 'minimal & elegant':
        return title.contains('minimal') ||
            desc.contains('leather') ||
            desc.contains('walnut') ||
            title.contains('frame');
      default:
        return title.contains(i) || desc.contains(i);
    }
  }
}

class _BudgetRange {
  final double min;
  final double max;

  const _BudgetRange(this.min, this.max);
}

class _ScoredProduct {
  final ProductModel product;
  final double score;
  final bool matchedBudget;
  final bool matchedRecipient;
  final bool matchedOccasion;
  final int matchedInterestsCount;

  const _ScoredProduct({
    required this.product,
    required this.score,
    required this.matchedBudget,
    required this.matchedRecipient,
    required this.matchedOccasion,
    required this.matchedInterestsCount,
  });
}
