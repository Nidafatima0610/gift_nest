import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/screens/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Splash Screen Logic', () {
    testWidgets('First launch: Splash navigates to Onboarding', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: AppRoutes.splash,
        ),
      );

      // Initially on Splash
      expect(find.text('Gift Nest'), findsOneWidget);

      // Wait for splash timer
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pumpAndSettle();

      // Should be on Onboarding
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text("Find a gift they'll love"), findsOneWidget);
    });

    testWidgets('Subsequent launch (onboarding_completed = true): Splash navigates to Login', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'onboarding_completed': true});

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: AppRoutes.splash,
        ),
      );

      // Initially on Splash
      expect(find.text('Gift Nest'), findsOneWidget);

      // Wait for splash timer
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pumpAndSettle();

      // Should be on Login
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    });
  });

  group('Onboarding Flow & Persistence', () {
    testWidgets('Swiping and Continue buttons advance through all 3 pages', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Page 1
      expect(find.text("Find a gift they'll love"), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

      // Tap Continue -> Advance to Page 2
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Page 2
      expect(find.text('Make it personal'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      // Tap Continue -> Advance to Page 3
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Page 3
      expect(find.text('Build your perfect gift'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      // Test Back button -> Return to Page 2
      await tester.tap(find.byKey(const Key('onboarding_back_button')));
      await tester.pumpAndSettle();
      expect(find.text('Make it personal'), findsOneWidget);

      // Test Horizontal Swiping (swipe right to go back to Page 1)
      await tester.drag(find.byType(PageView), const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text("Find a gift they'll love"), findsOneWidget);

      // Test Horizontal Swiping (swipe left to go to Page 2)
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('Make it personal'), findsOneWidget);
    });

    testWidgets('Tapping Get Started sets onboarding_completed to true and navigates to Login', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Advance to page 2
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Advance to page 3
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Tap Get Started
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Verify navigated to Login
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);

      // Verify SharedPreferences persisted
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('onboarding_completed'), isTrue);
    });

    testWidgets('Tapping Skip sets onboarding_completed to true and navigates to Login', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Skip on Page 1
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Verify navigated to Login
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);

      // Verify SharedPreferences persisted
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('onboarding_completed'), isTrue);
    });
  });
}
