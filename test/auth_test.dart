import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/core/widgets/app_text_field.dart';
import 'package:gift_nest/screens/auth/login_screen.dart';
import 'package:gift_nest/screens/auth/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Login Screen Tests', () {
    testWidgets('Renders all required elements and headers', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Headers
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text("Let's find something special for someone special."), findsOneWidget);

      // Input labels & fields
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);

      // Actions
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('Validates email and password requirements on empty submit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Log In with empty fields
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      // Inline validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Validates invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your email'), 'invalid-email');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), 'secret123');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Toggles password visibility on Login screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final passwordFieldFinder = find.descendant(
        of: find.widgetWithText(AppTextField, 'Password'),
        matching: find.byType(TextField),
      );
      TextField passwordField = tester.widget(passwordFieldFinder);
      expect(passwordField.obscureText, isTrue);

      // Tap toggle to unhide
      await tester.tap(find.byKey(const Key('login_password_visibility_toggle')));
      await tester.pumpAndSettle();

      passwordField = tester.widget(passwordFieldFinder);
      expect(passwordField.obscureText, isFalse);

      // Tap toggle to hide again
      await tester.tap(find.byKey(const Key('login_password_visibility_toggle')));
      await tester.pumpAndSettle();

      passwordField = tester.widget(passwordFieldFinder);
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('Navigates to Home on valid login credentials', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your email'), 'sarah@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), 'mypassword123');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      // Verify routed to Home
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });

    testWidgets('Continue as Guest navigates directly to Home', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('login_continue_as_guest')));
      await tester.tap(find.byKey(const Key('login_continue_as_guest')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });

    testWidgets('Sign Up link navigates to SignupScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login_to_signup_button')));
      await tester.pumpAndSettle();

      expect(find.text('Create your account'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Sign Up'), findsOneWidget);
    });

    testWidgets('Forgot password shows feedback SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot password?'));
      await tester.pump();

      expect(find.text('Password reset instructions will be available soon.'), findsOneWidget);
    });
  });

  group('Signup Screen Tests', () {
    testWidgets('Renders all required elements and headers', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: SignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Headers
      expect(find.text('Create your account'), findsOneWidget);
      expect(find.text('Start discovering thoughtful gifts made just for your special people.'), findsOneWidget);

      // Labels & inputs
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Actions
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('Validates required fields on empty submit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: SignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Validates password min 6 chars and password mismatch', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: SignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Fill name & email
      await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Jane Doe'), 'Jane Doe');
      await tester.enterText(find.widgetWithText(TextFormField, 'name@example.com'), 'jane@example.com');

      // Short password
      await tester.enterText(find.widgetWithText(TextFormField, 'Create a password (min. 6 characters)'), '123');
      await tester.enterText(find.widgetWithText(TextFormField, 'Re-enter your password'), '123456');

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Toggles password visibility on Signup screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: SignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final passwordFinder = find.descendant(
        of: find.widgetWithText(AppTextField, 'Password'),
        matching: find.byType(TextField),
      );
      final confirmFinder = find.descendant(
        of: find.widgetWithText(AppTextField, 'Confirm Password'),
        matching: find.byType(TextField),
      );

      expect(tester.widget<TextField>(passwordFinder).obscureText, isTrue);
      expect(tester.widget<TextField>(confirmFinder).obscureText, isTrue);

      // Toggle password
      await tester.tap(find.byKey(const Key('signup_password_visibility_toggle')));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(passwordFinder).obscureText, isFalse);

      // Toggle confirm password
      await tester.tap(find.byKey(const Key('signup_confirm_password_visibility_toggle')));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(confirmFinder).obscureText, isFalse);
    });

    testWidgets('Navigates to Home on valid signup submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: SignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Jane Doe'), 'Jane Doe');
      await tester.enterText(find.widgetWithText(TextFormField, 'name@example.com'), 'jane@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Create a password (min. 6 characters)'), 'password123');
      await tester.enterText(find.widgetWithText(TextFormField, 'Re-enter your password'), 'password123');

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });

    testWidgets('Signup Continue as Guest navigates to Home', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: SignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('signup_continue_as_guest')));
      await tester.tap(find.byKey(const Key('signup_continue_as_guest')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });
  });

  group('Responsive & Small Screen Tests', () {
    testWidgets('LoginScreen builds without overflow on small device (360x640)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SignupScreen builds without overflow on small device (360x640)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: SignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Create your account'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
