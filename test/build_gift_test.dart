import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/providers/build_gift_provider.dart';
import 'package:gift_nest/providers/cart_provider.dart';
import 'package:gift_nest/screens/build_gift/build_gift_screen.dart';
import 'package:gift_nest/screens/explore/data/explore_demo_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestScreen({
    BuildGiftProvider? buildGiftProvider,
    CartProvider? cartProvider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => cartProvider ?? CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => buildGiftProvider ?? BuildGiftProvider(),
        ),
      ],
      child: const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: BuildGiftScreen(),
      ),
    );
  }

  group('Build My Gift: Header & Step Indicator Tests', () {
    testWidgets('Renders AppBar, Header title, subtitle, and 3-step progress indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestScreen());
      await tester.pumpAndSettle();

      // AppBar title matching test expectations
      expect(find.widgetWithText(AppBar, 'Build Gift'), findsOneWidget);
      expect(find.byKey(const Key('build_gift_cart_icon')), findsOneWidget);

      // Header title & subtitle
      expect(find.text('Build My Gift'), findsOneWidget);
      expect(find.text('Create something special, made just for them.'), findsOneWidget);

      // Step indicators
      expect(find.text('Choose Gifts'), findsOneWidget);
      expect(find.text('Personalize'), findsOneWidget);
      expect(find.text('Review'), findsOneWidget);
    });
  });

  group('Build My Gift: Step 1 Choose Gifts & Product Selection', () {
    testWidgets('Renders warm intro card and product catalog grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestScreen());
      await tester.pumpAndSettle();

      expect(find.text('Create your perfect gift box 🎁'), findsOneWidget);
      expect(
        find.text("Pick a few things they'll love and make your own thoughtful combination."),
        findsOneWidget,
      );

      // Verify sample product cards are present
      final firstProduct = ExploreDemoData.catalogProducts.first;
      expect(find.text(firstProduct.title), findsOneWidget);
      expect(find.byKey(Key('add_to_box_${firstProduct.id}')), findsOneWidget);
    });

    testWidgets('Tapping Add adds product to box, increments quantity, and updates counter',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestScreen());
      await tester.pumpAndSettle();

      final prod1 = ExploreDemoData.catalogProducts[0];
      final prod2 = ExploreDemoData.catalogProducts[1];

      // Initially 0 of 6 selected
      expect(find.text('0 of 6 items selected'), findsOneWidget);

      // Tap Add on prod1
      await tester.tap(find.byKey(Key('add_to_box_${prod1.id}')));
      await tester.pumpAndSettle();

      // prod1 is now selected with quantity 1
      expect(find.byKey(Key('qty_text_${prod1.id}')), findsOneWidget);
      expect(find.text('1 of 6 items selected'), findsOneWidget);

      // Tap increase on prod1
      await tester.tap(find.byKey(Key('increase_qty_${prod1.id}')));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsWidgets); // quantity is 2

      // Tap Add on prod2
      await tester.tap(find.byKey(Key('add_to_box_${prod2.id}')));
      await tester.pumpAndSettle();

      // Now 2 of 6 items selected
      expect(find.text('2 of 6 items selected'), findsOneWidget);
    });

    testWidgets('Enforces minimum 2 products validation before continuing',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestScreen());
      await tester.pumpAndSettle();

      final prod1 = ExploreDemoData.catalogProducts[0];

      // Only add 1 product
      await tester.tap(find.byKey(Key('add_to_box_${prod1.id}')));
      await tester.pumpAndSettle();

      // Attempt to continue
      await tester.tap(find.byKey(const Key('build_gift_continue_button')));
      await tester.pump();

      // SnackBar shown
      expect(find.text('Choose at least 2 gifts for your box.'), findsOneWidget);

      // Still on Step 1
      expect(find.text('Create your perfect gift box 🎁'), findsOneWidget);
    });

    testWidgets('Enforces maximum 6 different products limit',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = BuildGiftProvider();
      await tester.pumpWidget(buildTestScreen(buildGiftProvider: provider));
      await tester.pumpAndSettle();

      // Add 6 products directly to reach limit
      for (int i = 0; i < 6; i++) {
        expect(provider.addProduct(ExploreDemoData.catalogProducts[i]), isTrue);
      }
      await tester.pumpAndSettle();

      expect(find.text('6 of 6 items selected'), findsOneWidget);
      expect(provider.isFull, isTrue);

      // Attempting to add 7th product to provider returns false
      final prod7 = ExploreDemoData.catalogProducts[6];
      expect(provider.addProduct(prod7), isFalse);
    });

    testWidgets('Toggles summary drawer to view items and price breakdown',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = BuildGiftProvider();
      final prod1 = ExploreDemoData.catalogProducts[0];
      final prod2 = ExploreDemoData.catalogProducts[1];
      provider.addProduct(prod1);
      provider.addProduct(prod2);

      await tester.pumpWidget(buildTestScreen(buildGiftProvider: provider));
      await tester.pumpAndSettle();

      // Tap header bar to expand summary
      await tester.tap(find.byKey(const Key('toggle_gift_box_summary')));
      await tester.pumpAndSettle();

      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Gift box service fee'), findsOneWidget);
      expect(find.byKey(const Key('summary_service_fee_text')), findsOneWidget);
      expect(find.text('PKR 199'), findsWidgets);

      // Remove an item via summary
      await tester.tap(find.byKey(Key('summary_remove_${prod1.id}')));
      await tester.pumpAndSettle();

      expect(find.text('1 of 6 items selected'), findsOneWidget);
    });
  });

  group('Build My Gift: Step 2 Personalize', () {
    testWidgets('Selects packaging style, edits personal message, attaches and removes photo',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = BuildGiftProvider();
      provider.addProduct(ExploreDemoData.catalogProducts[0]);
      provider.addProduct(ExploreDemoData.catalogProducts[1]);

      await tester.pumpWidget(buildTestScreen(buildGiftProvider: provider));
      await tester.pumpAndSettle();

      // Continue to Step 2
      await tester.tap(find.byKey(const Key('build_gift_continue_button')));
      await tester.pumpAndSettle();

      // Step 2 UI elements
      expect(find.text('Choose your style'), findsOneWidget);
      expect(find.text('Add a personal message 💌'), findsOneWidget);
      expect(find.text('Add a special memory'), findsOneWidget);

      // Select 'Soft & Romantic' packaging style
      await tester.tap(find.byKey(const Key('packaging_option_soft_&_romantic')));
      await tester.pumpAndSettle();
      expect(provider.packagingStyle, 'Soft & Romantic');

      // Enter personal message and verify live counter
      const message = 'Happy Birthday Sarah! Wishing you all the love.';
      await tester.enterText(
        find.byKey(const Key('gift_message_input')),
        message,
      );
      await tester.pumpAndSettle();

      expect(find.text('${message.length}/200'), findsOneWidget);
      expect(provider.personalMessage, message);

      // Attach memory photo
      await tester.ensureVisible(find.byKey(const Key('attach_photo_button')));
      await tester.tap(find.byKey(const Key('attach_photo_button')));
      await tester.pumpAndSettle();

      expect(find.text('Memory Attached'), findsOneWidget);
      expect(provider.hasPhoto, isTrue);

      // Remove photo
      await tester.tap(find.byKey(const Key('remove_photo_button')));
      await tester.pumpAndSettle();

      expect(provider.hasPhoto, isFalse);
    });

    testWidgets('Back button returns to Step 1 with selections preserved',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = BuildGiftProvider();
      provider.addProduct(ExploreDemoData.catalogProducts[0]);
      provider.addProduct(ExploreDemoData.catalogProducts[1]);

      await tester.pumpWidget(buildTestScreen(buildGiftProvider: provider));
      await tester.pumpAndSettle();

      // Proceed to Step 2
      await tester.tap(find.byKey(const Key('build_gift_continue_button')));
      await tester.pumpAndSettle();

      expect(find.text('Choose your style'), findsOneWidget);

      // Tap Back button
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      // Back at Step 1
      expect(find.text('Create your perfect gift box 🎁'), findsOneWidget);
      expect(find.text('2 of 6 items selected'), findsOneWidget);
    });
  });

  group('Build My Gift: Step 3 Review & Add to Cart', () {
    testWidgets('Renders complete review summary and adds gift box to CartProvider',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = BuildGiftProvider();
      final cartProvider = CartProvider();
      final prod1 = ExploreDemoData.catalogProducts[0];
      final prod2 = ExploreDemoData.catalogProducts[1];

      provider.addProduct(prod1);
      provider.addProduct(prod2);
      provider.setPackagingStyle('Festive');
      provider.setPersonalMessage('For the best sister ever!');

      await tester.pumpWidget(buildTestScreen(
        buildGiftProvider: provider,
        cartProvider: cartProvider,
      ));
      await tester.pumpAndSettle();

      // Navigate to Step 2
      await tester.tap(find.byKey(const Key('build_gift_continue_button')));
      await tester.pumpAndSettle();

      // Navigate to Step 3
      await tester.tap(find.byKey(const Key('continue_to_review_button')));
      await tester.pumpAndSettle();

      // Step 3 Review Content
      expect(find.text('Your Gift Box ✨'), findsOneWidget);
      expect(find.text('Festive'), findsOneWidget);
      expect(find.text('"For the best sister ever!"'), findsOneWidget);
      expect(find.text('Items Subtotal'), findsOneWidget);
      expect(find.text('Gift box service fee'), findsOneWidget);

      // Verify dynamic calculation
      final expectedTotal = prod1.price + prod2.price + BuildGiftProvider.serviceFee;
      expect(provider.total, expectedTotal);

      // Tap Add Gift Box to Cart
      await tester.ensureVisible(find.byKey(const Key('add_gift_box_to_cart_cta')));
      await tester.tap(find.byKey(const Key('add_gift_box_to_cart_cta')));
      await tester.pumpAndSettle();

      // Success dialog shown
      expect(find.text('Your gift box is ready 🎁'), findsOneWidget);
      expect(find.byKey(const Key('dialog_view_cart_button')), findsOneWidget);
      expect(find.byKey(const Key('dialog_continue_shopping_button')), findsOneWidget);

      // Verify cart contains the custom gift box
      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.first.isGiftBox, isTrue);
      expect(cartProvider.giftBoxes.length, 1);
      expect(cartProvider.giftBoxes.first.packagingStyle, 'Festive');
      expect(cartProvider.giftBoxes.first.personalMessage, 'For the best sister ever!');
    });

    testWidgets('Edit button returns to Step 1 to modify items',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = BuildGiftProvider();
      provider.addProduct(ExploreDemoData.catalogProducts[0]);
      provider.addProduct(ExploreDemoData.catalogProducts[1]);
      provider.setStep(2); // Jump directly to Step 3

      await tester.pumpWidget(buildTestScreen(buildGiftProvider: provider));
      await tester.pumpAndSettle();

      expect(find.text('Your Gift Box ✨'), findsOneWidget);

      // Tap Edit
      await tester.tap(find.byKey(const Key('edit_gift_box_button')));
      await tester.pumpAndSettle();

      // Returned to Step 1
      expect(find.text('Create your perfect gift box 🎁'), findsOneWidget);
      expect(provider.currentStep, 0);
    });
  });

  group('Build My Gift: Small Screen Responsiveness (360x640)', () {
    testWidgets('BuildGiftScreen builds and scrolls without RenderFlex overflow on small device',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = BuildGiftProvider();
      provider.addProduct(ExploreDemoData.catalogProducts[0]);
      provider.addProduct(ExploreDemoData.catalogProducts[1]);

      await tester.pumpWidget(buildTestScreen(buildGiftProvider: provider));
      await tester.pumpAndSettle();

      // Step 1 check
      expect(tester.takeException(), isNull);

      // Step 2 check
      provider.setStep(1);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Step 3 check
      provider.setStep(2);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
