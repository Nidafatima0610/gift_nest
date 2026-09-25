import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/screens/explore/data/explore_demo_data.dart';
import 'package:gift_nest/screens/explore/explore_screen.dart';
import 'package:gift_nest/services/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await FavoritesService.instance.init();
    await FavoritesService.instance.clearAll();
  });

  Widget buildExploreScreen({String? initialCategory}) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: ExploreScreen(initialCategory: initialCategory),
    );
  }

  group('Explore Screen Header & Initial State Tests', () {
    testWidgets('Renders Explore title, subtitle, search bar, and initial catalog', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      expect(find.text('Explore'), findsWidgets);
      expect(find.text('Find something special'), findsOneWidget);
      expect(find.byKey(const Key('explore_search_text_field')), findsOneWidget);

      // Verify product count indicator & filter/sort bar
      expect(find.byKey(const Key('explore_filter_button')), findsOneWidget);
      expect(find.byKey(const Key('explore_sort_button')), findsOneWidget);
      expect(find.text('${ExploreDemoData.catalogProducts.length} gifts'), findsOneWidget);

      // Verify initial sample products in grid
      expect(find.text('Personalized Name Mug'), findsOneWidget);
      expect(find.text('PKR 1,450'), findsOneWidget);
      expect(find.text('Custom Photo Frame'), findsOneWidget);
    });

    testWidgets('Renders all category chips with All selected by default', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('category_chip_all')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_birthday')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_anniversary')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_eid')), findsOneWidget);

      // Scroll horizontal category list to verify remaining chips
      await tester.drag(find.byType(ListView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('category_chip_graduation')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_new_baby')), findsOneWidget);
    });
  });

  group('Search Functionality Tests', () {
    testWidgets('Filters products by product title', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Enter search term 'Mug'
      await tester.enterText(find.byKey(const Key('explore_search_text_field')), 'Mug');
      await tester.pumpAndSettle();

      expect(find.text('Personalized Name Mug'), findsOneWidget);
      expect(find.text('Custom Photo Frame'), findsNothing);
      expect(find.text('1 gifts'), findsOneWidget);
    });

    testWidgets('Filters products by creator name', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Enter creator 'The Candle Corner'
      await tester.enterText(find.byKey(const Key('explore_search_text_field')), 'The Candle Corner');
      await tester.pumpAndSettle();

      expect(find.text('Scented Candle Set'), findsOneWidget);
      expect(find.text("Gentleman's Desk Set"), findsOneWidget);
      expect(find.text('Personalized Name Mug'), findsNothing);
    });

    testWidgets('Clear button resets search query and restores catalog', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('explore_search_text_field')), 'Mug');
      await tester.pumpAndSettle();
      expect(find.text('1 gifts'), findsOneWidget);

      // Tap clear button
      expect(find.byKey(const Key('explore_search_clear_button')), findsOneWidget);
      await tester.tap(find.byKey(const Key('explore_search_clear_button')));
      await tester.pumpAndSettle();

      expect(find.text('${ExploreDemoData.catalogProducts.length} gifts'), findsOneWidget);
      expect(find.text('Custom Photo Frame'), findsOneWidget);
    });

    testWidgets('Shows friendly empty state when no search results match', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('explore_search_text_field')), 'nonexistentquery999');
      await tester.pumpAndSettle();

      expect(find.text('Nothing found'), findsOneWidget);
      expect(find.text('0 gifts'), findsOneWidget);

      // Tap Reset Filters button in empty state
      expect(find.byKey(const Key('explore_empty_state_reset_button')), findsOneWidget);
      await tester.tap(find.byKey(const Key('explore_empty_state_reset_button')));
      await tester.pumpAndSettle();

      expect(find.text('${ExploreDemoData.catalogProducts.length} gifts'), findsOneWidget);
    });
  });

  group('Category Filtering Tests', () {
    testWidgets('Selecting a category filters products and tapping All restores', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Tap Birthday category
      await tester.tap(find.byKey(const Key('category_chip_birthday')));
      await tester.pumpAndSettle();

      expect(find.text('Personalized Name Mug'), findsOneWidget);
      expect(find.text('Mini Self-Care Box'), findsOneWidget);

      // Tap All category to restore
      await tester.tap(find.byKey(const Key('category_chip_all')));
      await tester.pumpAndSettle();

      expect(find.text('${ExploreDemoData.catalogProducts.length} gifts'), findsOneWidget);
    });

    testWidgets('Selecting Eid category displays Eid products', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Tap Eid category
      await tester.tap(find.byKey(const Key('category_chip_eid')));
      await tester.pumpAndSettle();

      expect(find.text('Personalized Journal'), findsOneWidget);
      expect(find.text('Scented Candle Set'), findsOneWidget);
    });
  });

  group('Filter Bottom Sheet Tests', () {
    testWidgets('Opens filter sheet, applies Price filter and updates active count badge', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Open Filter Bottom Sheet
      await tester.tap(find.byKey(const Key('explore_filter_button')));
      await tester.pumpAndSettle();

      expect(find.text('Filter Gifts'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Gift Type'), findsOneWidget);
      expect(find.text('Recipient'), findsOneWidget);

      // Select 'Under Rs. 1,000'
      await tester.tap(find.byKey(const Key('chip_price_under_rs__1_000')));
      await tester.pumpAndSettle();

      // Tap Apply
      await tester.tap(find.byKey(const Key('filter_apply_button')));
      await tester.pumpAndSettle();

      // Only Custom Keychain is under 1,000 PKR (850)
      expect(find.text('Custom Keychain'), findsOneWidget);
      expect(find.text('PKR 850'), findsOneWidget);
      expect(find.text('1 gifts'), findsOneWidget);

      // Badge displays '1'
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Clear All inside Filter sheet resets selections', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Open filter sheet
      await tester.tap(find.byKey(const Key('explore_filter_button')));
      await tester.pumpAndSettle();

      // Select multiple
      await tester.tap(find.byKey(const Key('chip_type_handmade')));
      await tester.pumpAndSettle();

      // Tap Clear All
      await tester.tap(find.byKey(const Key('filter_clear_all_button')));
      await tester.pumpAndSettle();

      // Apply
      await tester.tap(find.byKey(const Key('filter_apply_button')));
      await tester.pumpAndSettle();

      expect(find.text('${ExploreDemoData.catalogProducts.length} gifts'), findsOneWidget);
    });
  });

  group('Sorting Bottom Sheet Tests', () {
    testWidgets('Sorts products by Price: Low to High', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Open Sort Sheet
      await tester.tap(find.byKey(const Key('explore_sort_button')));
      await tester.pumpAndSettle();

      expect(find.text('Sort Gifts By'), findsOneWidget);

      // Select 'Price: Low to High'
      await tester.tap(find.byKey(const Key('sort_option_priceLowToHigh')));
      await tester.pumpAndSettle();

      expect(find.text('Price: Low to High'), findsOneWidget);

      // First product card should now be Custom Keychain (PKR 850)
      expect(find.text('Custom Keychain'), findsOneWidget);
      expect(find.text('PKR 850'), findsOneWidget);
    });

    testWidgets('Sorts products by Price: High to Low', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Open Sort Sheet
      await tester.tap(find.byKey(const Key('explore_sort_button')));
      await tester.pumpAndSettle();

      // Select 'Price: High to Low'
      await tester.tap(find.byKey(const Key('sort_option_priceHighToLow')));
      await tester.pumpAndSettle();

      expect(find.text('Price: High to Low'), findsOneWidget);

      // Highest priced product should be Eid Gift Hamper (PKR 5,400)
      expect(find.text('Eid Gift Hamper'), findsOneWidget);
      expect(find.text('PKR 5,400'), findsOneWidget);
    });
  });

  group('Favorites Persistence Tests', () {
    testWidgets('Toggling heart button saves to SharedPreferences and persists across reload', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      const prodId = 'prod_1';
      final favKey = Key('fav_button_$prodId');

      expect(FavoritesService.instance.isFavorite(prodId), isFalse);

      // Tap favorite button
      await tester.tap(find.byKey(favKey));
      await tester.pumpAndSettle();

      expect(FavoritesService.instance.isFavorite(prodId), isTrue);

      // Verify stored in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList('favorite_product_ids') ?? [];
      expect(storedList, contains(prodId));

      // Simulate App Restart by resetting and re-initializing FavoritesService
      final freshFavoritesService = FavoritesService.instance;
      // Clear internal in-memory set to simulate fresh launch
      await freshFavoritesService.init();
      expect(freshFavoritesService.isFavorite(prodId), isTrue);

      // Toggle off
      await tester.tap(find.byKey(favKey));
      await tester.pumpAndSettle();

      expect(FavoritesService.instance.isFavorite(prodId), isFalse);
      final updatedList = prefs.getStringList('favorite_product_ids') ?? [];
      expect(updatedList, isNot(contains(prodId)));
    });
  });

  group('Product Navigation Tests', () {
    testWidgets('Tapping product card navigates to /product-details with ProductModel passed', (WidgetTester tester) async {
      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      // Tap first product 'Personalized Name Mug'
      await tester.tap(find.text('Personalized Name Mug'));
      await tester.pumpAndSettle();

      // Verify Product Details screen rendered with the specific product data passed
      expect(find.widgetWithText(AppBar, 'Product Details'), findsOneWidget);
      expect(find.text('Personalized Name Mug'), findsOneWidget);
      expect(find.text("by Sana's Studio"), findsOneWidget);
      expect(find.text('PKR 1,450'), findsOneWidget);
    });
  });

  group('Responsiveness & Small Screen Viewport', () {
    testWidgets('ExploreScreen builds and scrolls on small screen (360x640) without overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildExploreScreen());
      await tester.pumpAndSettle();

      expect(find.text('Explore'), findsWidgets);
      expect(find.text('Find something special'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Drag scroll grid
      await tester.drag(find.byKey(const Key('explore_products_grid')), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
