import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/models/product_model.dart';
import 'package:gift_nest/providers/cart_provider.dart';
import 'package:gift_nest/screens/explore/data/explore_demo_data.dart';
import 'package:gift_nest/screens/product_details/product_details_screen.dart';
import 'package:gift_nest/services/favorites_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CartProvider cartProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await FavoritesService.instance.init();
    await FavoritesService.instance.clearAll();
    cartProvider = CartProvider();
    await cartProvider.init();
  });

  Widget buildProductDetailsScreen({ProductModel? product}) {
    return ChangeNotifierProvider<CartProvider>.value(
      value: cartProvider,
      child: MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: ProductDetailsScreen(
          initialProduct: product ?? ExploreDemoData.catalogProducts.first,
        ),
      ),
    );
  }

  group('Product Details Screen UI & Content Tests', () {
    testWidgets('Renders AppBar, product metadata, badges, and stock availability', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      // Top AppBar & Actions
      expect(find.widgetWithText(AppBar, 'Product Details'), findsOneWidget);
      expect(find.byKey(const Key('product_details_back_button')), findsOneWidget);
      expect(find.byKey(const Key('product_details_favorite_button')), findsOneWidget);
      expect(find.byKey(const Key('product_details_cart_button')), findsOneWidget);

      // Product Title, Creator, Price, Rating
      expect(find.text('Personalized Name Mug'), findsOneWidget);
      expect(find.text("by Sana's Studio"), findsOneWidget);
      expect(find.text('PKR 1,450'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('(38 reviews)'), findsOneWidget);

      // Badges
      expect(find.text('Personalizable'), findsOneWidget);
      expect(find.text('Handmade'), findsOneWidget);
      expect(find.text('Gift Ready'), findsOneWidget);

      // Availability / Stock Status
      expect(find.text('In Stock · Ready to Gift'), findsOneWidget);
    });

    testWidgets('Renders About this gift with expandable Read more toggle and details', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      expect(find.text('About this gift'), findsOneWidget);

      // Check Read more toggle
      final readMoreFinder = find.text('Read more');
      await tester.ensureVisible(readMoreFinder);
      await tester.pumpAndSettle();
      expect(readMoreFinder, findsOneWidget);
      await tester.tap(readMoreFinder);
      await tester.pumpAndSettle();
      expect(find.text('Read less'), findsOneWidget);

      // Check Details breakdown
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Material'), findsOneWidget);
      expect(find.text('Handmade Glazed Ceramic & 24k Gold Luster'), findsOneWidget);
      expect(find.text('Size'), findsOneWidget);
      expect(find.text('350 ml (12 oz)'), findsOneWidget);
      expect(find.text('Estimated prep time'), findsOneWidget);
      expect(find.text('2 business days'), findsOneWidget);
    });

    testWidgets('Renders Delivery card and Made by creator card', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      // Delivery Card
      final deliveryText = find.text('Delivery');
      await tester.ensureVisible(deliveryText);
      await tester.pumpAndSettle();
      expect(deliveryText, findsOneWidget);
      expect(find.text('Estimated delivery: 3–5 business days'), findsOneWidget);

      // Creator Card
      final madeByText = find.text('Made by');
      await tester.ensureVisible(madeByText);
      await tester.pumpAndSettle();
      expect(madeByText, findsOneWidget);
      expect(find.text("Sana's Studio"), findsOneWidget);
      expect(find.text('Karachi, PK'), findsOneWidget);
      expect(find.text('View Creator'), findsOneWidget);
    });
  });

  group('Personalization Workflow Tests', () {
    testWidgets('Displays Make it personal section with fields and live summary for customizable product', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      // Customization Header
      final customHeader = find.text('Make it personal ✨');
      await tester.ensureVisible(customHeader);
      await tester.pumpAndSettle();
      expect(customHeader, findsOneWidget);
      expect(find.text('Add your own special touch.'), findsOneWidget);

      // Name field
      final nameField = find.byKey(const Key('customization_name_field'));
      expect(nameField, findsOneWidget);
      expect(find.text('Enter a name'), findsOneWidget);

      // Message field
      expect(find.byKey(const Key('customization_message_field')), findsOneWidget);
      expect(find.text('Write a personal message...'), findsOneWidget);

      // Color chips
      expect(find.byKey(const Key('color_chip_blush_rose')), findsOneWidget);
      expect(find.byKey(const Key('color_chip_sage_green')), findsOneWidget);

      // Live summary initially empty prompt
      expect(find.text('Your personalization'), findsOneWidget);

      // Enter name in field
      await tester.enterText(nameField, 'Ayesha');
      await tester.pumpAndSettle();

      // Verify live summary updated with entered name
      expect(find.text('Ayesha'), findsWidgets);
    });

    testWidgets('Photo upload UI allows selecting, previewing, and removing photo', (WidgetTester tester) async {
      // Find photo customizable product (prod_2: Custom Photo Frame)
      final photoProduct = ExploreDemoData.catalogProducts.firstWhere((p) => p.id == 'prod_2');
      await tester.pumpWidget(buildProductDetailsScreen(product: photoProduct));
      await tester.pumpAndSettle();

      // Photo upload trigger
      final uploadTrigger = find.byKey(const Key('photo_upload_placeholder'));
      await tester.ensureVisible(uploadTrigger);
      await tester.pumpAndSettle();
      expect(uploadTrigger, findsOneWidget);
      expect(find.text('Upload keepsake photo'), findsOneWidget);

      // Tap to open photo choices sheet
      await tester.tap(uploadTrigger);
      await tester.pumpAndSettle();

      expect(find.text('Select Keepsake Photo'), findsOneWidget);
      expect(find.byKey(const Key('photo_option_portrait')), findsOneWidget);

      // Select Portrait photo
      await tester.tap(find.byKey(const Key('photo_option_portrait')));
      await tester.pumpAndSettle();

      // Verify photo preview card appeared
      expect(find.byKey(const Key('photo_preview_container')), findsOneWidget);
      expect(find.textContaining('Photo attached'), findsOneWidget);
      expect(find.byKey(const Key('replace_photo_button')), findsOneWidget);
      expect(find.byKey(const Key('remove_photo_button')), findsOneWidget);

      // Tap Remove photo
      await tester.tap(find.byKey(const Key('remove_photo_button')));
      await tester.pumpAndSettle();

      // Verify returned to upload placeholder
      expect(find.byKey(const Key('photo_upload_placeholder')), findsOneWidget);
    });
  });

  group('Quantity & Dynamic Pricing Tests', () {
    testWidgets('Quantity cannot go below 1, increments and dynamically updates total price', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      // Initial quantity is 1
      expect(find.byKey(const Key('quantity_value_text')), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      // Try decrement below 1 - should remain 1
      await tester.tap(find.byKey(const Key('quantity_decrement_button')));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // Initial base price is PKR 1,450
      expect(find.byKey(const Key('product_total_price_text')), findsOneWidget);
      expect(find.textContaining('PKR 1,450'), findsWidgets);

      // Enter personalization (adding PKR 250 personalization fee)
      await tester.enterText(find.byKey(const Key('customization_name_field')), 'Hamza');
      await tester.pumpAndSettle();

      // Price is now base (1450) + custom (250) = PKR 1,700 for 1 item
      expect(find.textContaining('PKR 1,700'), findsWidgets);

      // Increment quantity to 2
      await tester.tap(find.byKey(const Key('quantity_increment_button')));
      await tester.pumpAndSettle();

      // Quantity is now 2, total is 1700 * 2 = PKR 3,400
      expect(find.text('2'), findsOneWidget);
      expect(find.textContaining('PKR 3,400'), findsWidgets);
    });
  });

  group('Validation & Add to Cart Tests', () {
    testWidgets('Blocks Add to Cart if required name field is missing and displays validation SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      // Tap Add to Cart without entering name
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Should display friendly validation message
      expect(find.text('Please enter a name for your personalized gift ✨'), findsOneWidget);

      // Cart should remain empty
      expect(cartProvider.isEmpty, isTrue);
    });

    testWidgets('Allows Add to Cart once required fields are provided and shows confirmation SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      // Enter valid recipient name
      await tester.enterText(find.byKey(const Key('customization_name_field')), 'Zainab');
      await tester.pumpAndSettle();

      // Tap Add to Cart
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Verify confirmation SnackBar
      expect(find.text('Added to your gift basket 🎁'), findsOneWidget);
      expect(find.text('View Cart'), findsOneWidget);

      // Verify cart has item with personalization
      expect(cartProvider.itemCount, equals(1));
      expect(cartProvider.items.first.product.title, equals('Personalized Name Mug'));
      expect(cartProvider.items.first.personalizations?['Name'], equals('Zainab'));
    });

    testWidgets('Non-customizable products can be added to cart directly without validation prompt', (WidgetTester tester) async {
      final nonCustomProduct = ExploreDemoData.catalogProducts.firstWhere((p) => !p.isCustomizable);
      await tester.pumpWidget(buildProductDetailsScreen(product: nonCustomProduct));
      await tester.pumpAndSettle();

      // Tap Add to Cart directly
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      expect(find.text('Added to your gift basket 🎁'), findsOneWidget);
      expect(cartProvider.itemCount, equals(1));
    });
  });

  group('Favorites Toggle & Persistence', () {
    testWidgets('Tapping favorite heart updates state and persists to SharedPreferences', (WidgetTester tester) async {
      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      final favButton = find.byKey(const Key('product_details_favorite_button'));
      expect(favButton, findsOneWidget);

      // Initially not favorite
      expect(FavoritesService.instance.isFavorite('prod_1'), isFalse);

      // Tap favorite button
      await tester.tap(favButton);
      await tester.pumpAndSettle();

      // State updated
      expect(FavoritesService.instance.isFavorite('prod_1'), isTrue);

      // Verify stored in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('favorite_product_ids') ?? [];
      expect(list, contains('prod_1'));

      // Tap again to toggle off
      await tester.tap(favButton);
      await tester.pumpAndSettle();
      expect(FavoritesService.instance.isFavorite('prod_1'), isFalse);
    });
  });

  group('Small Screen Responsiveness', () {
    testWidgets('ProductDetailsScreen scrolls cleanly without RenderFlex overflow on small device (360x640)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildProductDetailsScreen());
      await tester.pumpAndSettle();

      // Verify no overflow error and scroll works
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('Made by'), findsOneWidget);
      expect(find.byKey(const Key('add_to_cart_button')), findsOneWidget);
    });
  });
}
