import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/providers/cart_provider.dart';
import 'package:gift_nest/screens/gift_finder/gift_finder_screen.dart';
import 'package:gift_nest/screens/gift_finder/models/gift_finder_state.dart';
import 'package:gift_nest/services/favorites_service.dart';
import 'package:gift_nest/services/gift_recommendation_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await FavoritesService.instance.init();
    await FavoritesService.instance.clearAll();
  });

  Widget buildGiftFinderScreen() {
    return ChangeNotifierProvider<CartProvider>(
      create: (_) => CartProvider(),
      child: const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: GiftFinderScreen(),
      ),
    );
  }

  group('Gift Finder Step Flow & Quiz Experience', () {
    testWidgets('Step 1 (Who?): Renders options, enforces selection before Continue', (WidgetTester tester) async {
      await tester.pumpWidget(buildGiftFinderScreen());
      await tester.pumpAndSettle();

      // Top Header & Step Progress
      expect(find.widgetWithText(AppBar, 'Gift Finder'), findsOneWidget);
      expect(find.text('Find My Gift 🎁'), findsOneWidget);
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.text('Who are you gifting?'), findsOneWidget);

      // Verify recipient options
      expect(find.text('Mom'), findsOneWidget);
      expect(find.text('Dad'), findsOneWidget);
      expect(find.text('Partner'), findsOneWidget);
      expect(find.text('Friend'), findsOneWidget);
      expect(find.text('Sister'), findsOneWidget);
      expect(find.text('Brother'), findsOneWidget);
      expect(find.text('Child'), findsOneWidget);
      expect(find.text('Colleague'), findsOneWidget);

      // Continue button should be disabled before selection
      final continueButtonFinder = find.byKey(const Key('gift_finder_continue_button'));
      expect(continueButtonFinder, findsOneWidget);

      final continueButton = tester.widget<ElevatedButton>(continueButtonFinder);
      expect(continueButton.onPressed, isNull);

      // Select 'Mom'
      await tester.tap(find.byKey(const Key('recipient_card_mom')));
      await tester.pumpAndSettle();

      // Continue button is now enabled
      final enabledButton = tester.widget<ElevatedButton>(continueButtonFinder);
      expect(enabledButton.onPressed, isNotNull);

      // Tap Continue to go to Step 2
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text("What's the occasion?"), findsOneWidget);
    });

    testWidgets('Step 2 (Occasion): Enforces selection, Back button preserves Step 1 choice', (WidgetTester tester) async {
      await tester.pumpWidget(buildGiftFinderScreen());
      await tester.pumpAndSettle();

      // Complete Step 1: Mom
      await tester.tap(find.byKey(const Key('recipient_card_mom')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 2 assertions
      expect(find.text("What's the occasion?"), findsOneWidget);
      expect(find.text('Birthday'), findsOneWidget);
      expect(find.text('Anniversary'), findsOneWidget);
      expect(find.text('Eid'), findsOneWidget);
      expect(find.text('Wedding'), findsOneWidget);

      // Back button works and returns to Step 1 with Mom selected
      await tester.tap(find.byKey(const Key('gift_finder_back_button')));
      await tester.pumpAndSettle();
      expect(find.text('Step 1 of 4'), findsOneWidget);

      // Advance again to Step 2
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Select 'Birthday'
      await tester.tap(find.byKey(const Key('occasion_card_birthday')));
      await tester.pumpAndSettle();

      // Advance to Step 3
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      expect(find.text('Step 3 of 4'), findsOneWidget);
      expect(find.text('What are they into?'), findsOneWidget);
    });

    testWidgets('Step 3 (Interests): Allows multiple selections and enforces at least one', (WidgetTester tester) async {
      await tester.pumpWidget(buildGiftFinderScreen());
      await tester.pumpAndSettle();

      // Step 1: Friend
      final friendCard = find.byKey(const Key('recipient_card_friend'));
      await tester.ensureVisible(friendCard);
      await tester.pumpAndSettle();
      await tester.tap(friendCard);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 2: Birthday
      final bdayCard = find.byKey(const Key('occasion_card_birthday'));
      await tester.ensureVisible(bdayCard);
      await tester.pumpAndSettle();
      await tester.tap(bdayCard);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 3
      expect(find.text('What are they into?'), findsOneWidget);
      final continueButton = tester.widget<ElevatedButton>(find.byKey(const Key('gift_finder_continue_button')));
      expect(continueButton.onPressed, isNull);

      // Select 'Home Decor' and 'Handmade' (multi-select)
      final homeDecor = find.byKey(const Key('interest_chip_home_decor'));
      await tester.ensureVisible(homeDecor);
      await tester.pumpAndSettle();
      await tester.tap(homeDecor);
      await tester.pumpAndSettle();
      final handmadeChip = find.byKey(const Key('interest_chip_handmade'));
      await tester.ensureVisible(handmadeChip);
      await tester.pumpAndSettle();
      await tester.tap(handmadeChip);
      await tester.pumpAndSettle();

      // Continue should now be enabled
      final enabledBtn = tester.widget<ElevatedButton>(find.byKey(const Key('gift_finder_continue_button')));
      expect(enabledBtn.onPressed, isNotNull);

      // Advance to Step 4
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      expect(find.text('Step 4 of 4'), findsOneWidget);
      expect(find.text("What's your budget?"), findsOneWidget);
    });

    testWidgets('Step 4 (Budget): Selects tier and finds gifts, presenting results grid', (WidgetTester tester) async {
      await tester.pumpWidget(buildGiftFinderScreen());
      await tester.pumpAndSettle();

      // Step 1: Mom
      await tester.tap(find.byKey(const Key('recipient_card_mom')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 2: Birthday
      await tester.tap(find.byKey(const Key('occasion_card_birthday')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 3: Self Care & Home Decor
      await tester.tap(find.byKey(const Key('interest_chip_self_care')));
      await tester.pumpAndSettle();
      final homeDecorChip = find.byKey(const Key('interest_chip_home_decor'));
      await tester.ensureVisible(homeDecorChip);
      await tester.pumpAndSettle();
      await tester.tap(homeDecorChip);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 4: Budget
      expect(find.text('Under Rs. 1,000'), findsOneWidget);
      expect(find.text('Rs. 1,000 – 2,500'), findsOneWidget);
      expect(find.text('Rs. 2,500 – 5,000'), findsOneWidget);

      // Select 'Rs. 1,000 – 2,500' (index 1)
      await tester.tap(find.byKey(const Key('budget_card_1')));
      await tester.pumpAndSettle();

      // Tap Find Gifts
      final findGiftsBtn = find.byKey(const Key('gift_finder_find_gifts_button'));
      expect(findGiftsBtn, findsOneWidget);
      await tester.tap(findGiftsBtn);
      await tester.pumpAndSettle();

      // Results Screen
      expect(find.text('Gift ideas for them ✨'), findsOneWidget);
      expect(find.byKey(const Key('gift_finder_results_subtitle')), findsOneWidget);
      expect(find.text('We found these for you'), findsOneWidget);
      expect(find.byKey(const Key('gift_finder_change_answers_button')), findsOneWidget);
      expect(find.byKey(const Key('gift_finder_start_over_button')), findsOneWidget);
    });
  });

  group('Results Actions: Change Answers & Start Over', () {
    testWidgets('Change Answers returns to quiz with answers preserved', (WidgetTester tester) async {
      await tester.pumpWidget(buildGiftFinderScreen());
      await tester.pumpAndSettle();

      // Step 1: Mom
      await tester.tap(find.byKey(const Key('recipient_card_mom')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 2: Birthday
      await tester.tap(find.byKey(const Key('occasion_card_birthday')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 3: Handmade
      final handmadeChip = find.byKey(const Key('interest_chip_handmade'));
      await tester.ensureVisible(handmadeChip);
      await tester.pumpAndSettle();
      await tester.tap(handmadeChip);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Step 4: Budget Rs. 1,000 – 2,500
      await tester.tap(find.byKey(const Key('budget_card_1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_find_gifts_button')));
      await tester.pumpAndSettle();

      // Results rendered
      expect(find.text('Gift ideas for them ✨'), findsOneWidget);

      // Tap Change Answers
      await tester.ensureVisible(find.byKey(const Key('gift_finder_change_answers_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_change_answers_button')));
      await tester.pumpAndSettle();

      // Returns to quiz on Step 4
      expect(find.text("What's your budget?"), findsOneWidget);
      expect(find.byKey(const Key('gift_finder_find_gifts_button')), findsOneWidget);
    });

    testWidgets('Start Over resets state and returns to Step 1', (WidgetTester tester) async {
      await tester.pumpWidget(buildGiftFinderScreen());
      await tester.pumpAndSettle();

      // Step 1: Dad
      await tester.tap(find.byKey(const Key('recipient_card_dad')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('gift_finder_continue_button')));
      await tester.pumpAndSettle();

      // Tap Start Over in AppBar
      await tester.tap(find.byKey(const Key('gift_finder_reset_button')));
      await tester.pumpAndSettle();

      // Returned to Step 1 and selection cleared
      expect(find.text('Step 1 of 4'), findsOneWidget);
      final continueBtn = tester.widget<ElevatedButton>(find.byKey(const Key('gift_finder_continue_button')));
      expect(continueBtn.onPressed, isNull);
    });
  });

  group('GiftRecommendationService Unit Logic Tests', () {
    test('Calculates ranked recommendations deterministically based on parameters', () {
      const service = GiftRecommendationService();
      final state = GiftFinderState(
        recipient: 'Mom',
        occasion: 'Birthday',
        interests: const {'Home Decor', 'Handmade'},
        budget: 'Rs. 1,000 – 2,500',
      );

      final result = service.recommendGifts(state);

      expect(result.products.isNotEmpty, isTrue);
      expect(result.summarySubtitle, equals('For Mom • Birthday • Rs. 1,000 – 2,500'));

      // Ceramic Mug (prod_1) is for Her/Friends, handmade, 1450 PKR -> top match
      expect(result.products.first.id, equals('prod_1'));
    });

    test('Provides fallback ideas rather than empty list when matches are sparse', () {
      const service = GiftRecommendationService();
      final sparseState = GiftFinderState(
        recipient: 'Child',
        occasion: 'Graduation',
        interests: const {'Tech'},
        budget: 'Rs. 10,000+',
      );

      final result = service.recommendGifts(sparseState);

      // Must never return empty list
      expect(result.products.isNotEmpty, isTrue);
      expect(result.isExactMatch, isFalse);
    });
  });

  group('Small Screen Viewport Responsiveness', () {
    testWidgets('GiftFinderScreen renders and scrolls on small screen (360x640) without overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildGiftFinderScreen());
      await tester.pumpAndSettle();

      // Step 1
      expect(find.text('Who are you gifting?'), findsOneWidget);

      // Scroll options grid
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('gift_finder_continue_button')), findsOneWidget);
    });
  });
}
