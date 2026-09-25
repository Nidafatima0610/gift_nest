import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Route Resolution Tests', () {
    testWidgets('Resolves /splash and renders brand text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: AppRoutes.splash,
        ),
      );
      expect(find.text('Gift Nest'), findsOneWidget);
      expect(find.text('Thoughtful gifts, made personal.'), findsOneWidget);

      // Settle timer
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pumpAndSettle();
    });

    testWidgets('Resolves /onboarding and renders first page title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: AppRoutes.onboarding,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("Find a gift they'll love"), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    final appBarRoutes = [
      (AppRoutes.login, 'Login'),
      (AppRoutes.signup, 'Sign Up'),
      (AppRoutes.home, 'Home'),
      (AppRoutes.explore, 'Explore'),
      (AppRoutes.giftFinder, 'Gift Finder'),
      (AppRoutes.productDetails, 'Product Details'),
      (AppRoutes.buildGift, 'Build Gift'),
      (AppRoutes.favorites, 'Favorites'),
      (AppRoutes.cart, 'Cart'),
      (AppRoutes.checkout, 'Checkout'),
      (AppRoutes.orders, 'Orders'),
      (AppRoutes.profile, 'Profile'),
    ];

    for (final route in appBarRoutes) {
      testWidgets('Resolves ${route.$1} and renders ${route.$2}', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: route.$1,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.widgetWithText(AppBar, route.$2), findsOneWidget);
      });
    }
  });
}
