import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildHomeScreen() {
    return const MaterialApp(
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: HomeScreen(),
    );
  }

  group('Home Screen UI & Content Tests', () {
    testWidgets('Renders Top Header with greeting, notifications and profile avatar', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      // Top Header Greeting
      expect(find.text('Good morning 👋'), findsOneWidget);
      expect(find.text('Find something special\nfor someone special.'), findsOneWidget);

      // Notification button
      expect(find.byKey(const Key('home_notification_button')), findsOneWidget);

      // Profile avatar button
      expect(find.byKey(const Key('home_profile_avatar_button')), findsOneWidget);
      expect(find.text('GN'), findsOneWidget);
    });

    testWidgets('Tapping notification button shows feedback SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_notification_button')));
      await tester.pump();

      expect(find.text('You have no new notifications right now.'), findsOneWidget);
    });

    testWidgets('Tapping profile avatar navigates to /profile', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_profile_avatar_button')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);
    });

    testWidgets('Renders search bar and tapping navigates to /explore', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.text('Search gifts, creators or occasions'), findsOneWidget);

      await tester.tap(find.byKey(const Key('home_search_bar')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Explore'), findsOneWidget);
    });

    testWidgets('Hero Card: Find My Gift navigates to /gift-finder', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.text("Don't know what to gift?"), findsOneWidget);
      expect(
        find.text("Tell us who it's for, the occasion and your budget. We'll help you find something special."),
        findsOneWidget,
      );
      expect(find.text('Find My Gift'), findsOneWidget);

      await tester.tap(find.byKey(const Key('home_find_my_gift_cta')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Gift Finder'), findsOneWidget);
    });

    testWidgets('Shop by Occasion renders all occasions and navigates on tap', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.text('Shop by Occasion'), findsOneWidget);
      expect(find.text('Birthday'), findsOneWidget);
      expect(find.text('Anniversary'), findsOneWidget);
      expect(find.text('Graduation'), findsOneWidget);

      // Tap an occasion card
      await tester.tap(find.byKey(const Key('occasion_birthday')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Explore'), findsOneWidget);
    });

    testWidgets('Trending Gifts renders products, PKR prices, favorite toggling, and navigates to details', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      // Ensure Trending Gifts is scrolled into view vertically
      await tester.ensureVisible(find.text('Trending Gifts'));
      await tester.pumpAndSettle();

      expect(find.text('Trending Gifts'), findsOneWidget);
      expect(find.text('Popular picks people are loving'), findsOneWidget);

      // Verify sample product
      expect(find.text('Personalized Name Mug'), findsOneWidget);
      expect(find.text('PKR 1,450'), findsOneWidget);
      expect(find.text("Sana's Studio"), findsWidgets);

      // Toggle favorite on first product
      final favKey = const Key('fav_button_prod_1');
      await tester.tap(find.byKey(favKey));
      await tester.pumpAndSettle();

      // Tap product card -> navigates to /product-details
      await tester.tap(find.text('Personalized Name Mug'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Product Details'), findsOneWidget);
    });

    testWidgets('Build My Gift promotional card navigates to /build-gift', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('home_start_building_cta')));
      expect(find.text("Create a gift box that's completely yours."), findsOneWidget);
      expect(find.text('Start Building'), findsOneWidget);

      await tester.tap(find.byKey(const Key('home_start_building_cta')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Build Gift'), findsOneWidget);
    });

    testWidgets('From Local Creators renders creators and creator data', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('From Local Creators'));
      expect(find.text('From Local Creators'), findsOneWidget);
      expect(find.text('Discover something handmade and meaningful'), findsOneWidget);

      expect(find.text("Sana's Studio"), findsWidgets);
      expect(find.text('The Candle Corner'), findsOneWidget);
    });
  });

  group('Bottom Navigation Tests', () {
    testWidgets('Renders all 5 navigation tabs with Home selected', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nav_tab_home')), findsOneWidget);
      expect(find.byKey(const Key('nav_tab_explore')), findsOneWidget);
      expect(find.byKey(const Key('nav_tab_build')), findsOneWidget);
      expect(find.byKey(const Key('nav_tab_favorites')), findsOneWidget);
      expect(find.byKey(const Key('nav_tab_profile')), findsOneWidget);
    });

    testWidgets('Tapping Explore navigates to /explore', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_tab_explore')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Explore'), findsOneWidget);
    });

    testWidgets('Tapping center Build tab navigates to /build-gift', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_tab_build')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Build Gift'), findsOneWidget);
    });

    testWidgets('Tapping Favorites navigates to /favorites', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_tab_favorites')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Favorites'), findsOneWidget);
    });

    testWidgets('Tapping Profile navigates to /profile', (WidgetTester tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_tab_profile')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);
    });
  });

  group('Small Screen / Mobile Viewport Responsiveness', () {
    testWidgets('HomeScreen builds and scrolls cleanly on small screen (360x640) without overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.text('Good morning 👋'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Test vertical drag scrolling
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
