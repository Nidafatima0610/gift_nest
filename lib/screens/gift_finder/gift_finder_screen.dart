import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../services/gift_recommendation_service.dart';
import 'models/gift_finder_state.dart';
import 'widgets/budget_option_card.dart';
import 'widgets/gift_finder_option_card.dart';
import 'widgets/gift_finder_progress.dart';
import 'widgets/gift_results_grid.dart';

/// Complete interactive Gift Finder / Find My Gift quiz flow.
class GiftFinderScreen extends StatefulWidget {
  const GiftFinderScreen({super.key});

  @override
  State<GiftFinderScreen> createState() => _GiftFinderScreenState();
}

class _GiftFinderScreenState extends State<GiftFinderScreen> {
  int _currentStep = 0; // 0: Who, 1: Occasion, 2: Interests, 3: Budget
  bool _showResults = false;

  GiftFinderState _state = GiftFinderState.initial();
  GiftRecommendationResult? _result;

  final GiftRecommendationService _recommendationService =
      const GiftRecommendationService();

  static const List<_QuizOption> _recipients = [
    _QuizOption('Mom', Icons.favorite_outline_rounded),
    _QuizOption('Dad', Icons.thumb_up_alt_outlined),
    _QuizOption('Partner', Icons.favorite_rounded),
    _QuizOption('Friend', Icons.sentiment_satisfied_alt_rounded),
    _QuizOption('Sister', Icons.face_3_outlined),
    _QuizOption('Brother', Icons.face_6_outlined),
    _QuizOption('Child', Icons.child_care_rounded),
    _QuizOption('Colleague', Icons.business_center_outlined),
  ];

  static const List<_QuizOption> _occasions = [
    _QuizOption('Birthday', Icons.cake_outlined),
    _QuizOption('Anniversary', Icons.favorite_border_rounded),
    _QuizOption('Eid', Icons.nights_stay_outlined),
    _QuizOption('Wedding', Icons.celebration_outlined),
    _QuizOption('Graduation', Icons.school_outlined),
    _QuizOption('New Baby', Icons.child_friendly_outlined),
    _QuizOption('Thank You', Icons.loyalty_outlined),
    _QuizOption('Get Well', Icons.healing_outlined),
    _QuizOption('Just Because', Icons.auto_awesome_outlined),
  ];

  static const List<_QuizOption> _interests = [
    _QuizOption('Fashion', Icons.checkroom_outlined),
    _QuizOption('Beauty', Icons.spa_outlined),
    _QuizOption('Self Care', Icons.bubble_chart_outlined),
    _QuizOption('Home Decor', Icons.chair_outlined),
    _QuizOption('Books', Icons.menu_book_rounded),
    _QuizOption('Food & Sweets', Icons.bakery_dining_outlined),
    _QuizOption('Jewelry', Icons.diamond_outlined),
    _QuizOption('Stationery', Icons.edit_note_outlined),
    _QuizOption('Tech', Icons.devices_outlined),
    _QuizOption('Handmade', Icons.palette_outlined),
    _QuizOption('Cute & Kawaii', Icons.cruelty_free_outlined),
    _QuizOption('Minimal & Elegant', Icons.architecture_outlined),
  ];

  static const List<_BudgetTier> _budgets = [
    _BudgetTier(
      label: 'Under Rs. 1,000',
      subtitle: 'Sweet little tokens & charming accessories',
      icon: Icons.savings_outlined,
    ),
    _BudgetTier(
      label: 'Rs. 1,000 – 2,500',
      subtitle: 'Handmade mugs, jewelry & personalized journals',
      icon: Icons.card_giftcard_rounded,
    ),
    _BudgetTier(
      label: 'Rs. 2,500 – 5,000',
      subtitle: 'Self-care sets, photo frames & custom keepsakes',
      icon: Icons.inventory_2_outlined,
    ),
    _BudgetTier(
      label: 'Rs. 5,000 – 10,000',
      subtitle: 'Deluxe hampers & celebration gift boxes',
      icon: Icons.diamond_outlined,
    ),
    _BudgetTier(
      label: 'Rs. 10,000+',
      subtitle: 'Luxury bespoke artisan gift collections',
      icon: Icons.workspace_premium_outlined,
    ),
  ];

  void _onNextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Calculate recommendations and show results
      final result = _recommendationService.recommendGifts(_state);
      setState(() {
        _result = result;
        _showResults = true;
      });
    }
  }

  void _onPreviousStep() {
    if (_showResults) {
      setState(() {
        _showResults = false;
      });
    } else if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _startOver() {
    setState(() {
      _currentStep = 0;
      _showResults = false;
      _state = GiftFinderState.initial();
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gift Finder'),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          key: const Key('gift_finder_app_bar_back_button'),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkPrimary),
          onPressed: _onPreviousStep,
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            key: const Key('gift_finder_reset_button'),
            icon: const Icon(Icons.restart_alt_rounded, color: AppColors.darkPrimary),
            tooltip: 'Start Over',
            onPressed: _startOver,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.darkPrimary),
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showResults && _result != null
              ? GiftResultsGrid(
                  key: const ValueKey('gift_results_view'),
                  result: _result!,
                  onChangeAnswers: () {
                    setState(() {
                      _showResults = false;
                    });
                  },
                  onStartOver: _startOver,
                )
              : _buildQuizView(),
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    final canContinue = _state.canContinue(_currentStep);

    return Column(
      children: [
        const SizedBox(height: 8),

        // Progress bar (Step X of 4)
        GiftFinderProgress(
          currentStep: _currentStep,
          totalSteps: 4,
        ),

        const SizedBox(height: 12),

        // Scrollable Question & Options Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Subtitle Header
                const Text(
                  'Find My Gift 🎁',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tell us a little about them and we'll find some ideas.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.secondaryText,
                  ),
                ),

                const SizedBox(height: 20),

                // Question Prompt
                Text(
                  _getStepQuestion(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStepSubtitle(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),

                const SizedBox(height: 16),

                // Dynamic Step Options
                _buildStepContent(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Sticky Bottom Controls (Back & Continue/Find Gifts)
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.lg,
            12,
            AppDimensions.lg,
            16,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              if (_currentStep > 0) ...[
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    key: const Key('gift_finder_back_button'),
                    onPressed: _onPreviousStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkPrimary,
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  key: _currentStep == 3
                      ? const Key('gift_finder_find_gifts_button')
                      : const Key('gift_finder_continue_button'),
                  onPressed: canContinue ? _onNextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.warmCream,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
                    disabledForegroundColor: AppColors.warmCream.withValues(alpha: 0.6),
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep == 3 ? 'Find Gifts' : 'Continue',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _currentStep == 3
                            ? Icons.auto_awesome_rounded
                            : Icons.arrow_forward_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStepQuestion() {
    switch (_currentStep) {
      case 0:
        return 'Who are you gifting?';
      case 1:
        return "What's the occasion?";
      case 2:
        return 'What are they into?';
      case 3:
        return "What's your budget?";
      default:
        return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Select the primary recipient for your gift.';
      case 1:
        return 'Every milestone calls for a different sentiment.';
      case 2:
        return 'Pick one or more interests to guide our recommendations.';
      case 3:
        return "We'll suggest thoughtful options within your price range.";
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildRecipientGrid();
      case 1:
        return _buildOccasionGrid();
      case 2:
        return _buildInterestsGrid();
      case 3:
        return _buildBudgetList();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Who?
  Widget _buildRecipientGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recipients.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final opt = _recipients[index];
        final isSelected = _state.recipient == opt.label;
        return GiftFinderOptionCard(
          key: Key('recipient_card_${opt.label.toLowerCase()}'),
          label: opt.label,
          icon: opt.icon,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _state = _state.copyWith(recipient: opt.label);
            });
          },
        );
      },
    );
  }

  // Step 2: Occasion
  Widget _buildOccasionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _occasions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final opt = _occasions[index];
        final isSelected = _state.occasion == opt.label;
        return GiftFinderOptionCard(
          key: Key('occasion_card_${opt.label.toLowerCase().replaceAll(' ', '_')}'),
          label: opt.label,
          icon: opt.icon,
          isCompact: true,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _state = _state.copyWith(occasion: opt.label);
            });
          },
        );
      },
    );
  }

  // Step 3: Interests (Multi-select)
  Widget _buildInterestsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _interests.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final opt = _interests[index];
        final isSelected = _state.interests.contains(opt.label);
        return GiftFinderOptionCard(
          key: Key(
            'interest_chip_${opt.label.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and')}',
          ),
          label: opt.label,
          icon: opt.icon,
          isCompact: true,
          isSelected: isSelected,
          onTap: () {
            final updated = Set<String>.from(_state.interests);
            if (isSelected) {
              updated.remove(opt.label);
            } else {
              updated.add(opt.label);
            }
            setState(() {
              _state = _state.copyWith(interests: updated);
            });
          },
        );
      },
    );
  }

  // Step 4: Budget
  Widget _buildBudgetList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _budgets.length,
      itemBuilder: (context, index) {
        final tier = _budgets[index];
        final isSelected = _state.budget == tier.label;
        return BudgetOptionCard(
          key: Key('budget_card_$index'),
          label: tier.label,
          subtitle: tier.subtitle,
          icon: tier.icon,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _state = _state.copyWith(budget: tier.label);
            });
          },
        );
      },
    );
  }
}

class _QuizOption {
  final String label;
  final IconData icon;

  const _QuizOption(this.label, this.icon);
}

class _BudgetTier {
  final String label;
  final String subtitle;
  final IconData icon;

  const _BudgetTier({
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}
