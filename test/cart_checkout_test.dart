import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/core/routes/app_routes.dart';
import 'package:gift_nest/models/cart_model.dart';
import 'package:gift_nest/models/gift_box_model.dart';
import 'package:gift_nest/models/order_model.dart';
import 'package:gift_nest/models/product_model.dart';
import 'package:gift_nest/providers/build_gift_provider.dart';
import 'package:gift_nest/providers/cart_provider.dart';
import 'package:gift_nest/providers/favorites_provider.dart';
import 'package:gift_nest/providers/order_provider.dart';
import 'package:gift_nest/screens/cart/cart_screen.dart';
import 'package:gift_nest/screens/checkout/checkout_screen.dart';
import 'package:gift_nest/screens/orders/orders_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late FavoritesProvider favoritesProvider;
  late BuildGiftProvider buildGiftProvider;

  final sampleProduct = ProductModel(
    id: 'prod_test_1',
    title: 'Handmade Lavender Candle',
    description: 'Calming soy wax candle',
    price: 1500.0,
    categoryId: 'home_living',
    creatorId: 'creator_1',
    creatorName: 'Aura Studio',
    inStock: true,
  );

  final sampleProduct2 = ProductModel(
    id: 'prod_test_2',
    title: 'Embroidered Bookmark',
    description: 'Floral silk bookmark',
    price: 800.0,
    categoryId: 'crafts',
    creatorId: 'creator_2',
    creatorName: 'Knot & Loom',
    inStock: true,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    cartProvider = CartProvider();
    orderProvider = OrderProvider();
    favoritesProvider = FavoritesProvider();
    buildGiftProvider = BuildGiftProvider();

    await cartProvider.init();
    await orderProvider.init();
    await favoritesProvider.init();
  });

  Widget buildTestApp({
    Widget? home,
    String? initialRoute,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ChangeNotifierProvider<OrderProvider>.value(value: orderProvider),
        ChangeNotifierProvider<FavoritesProvider>.value(value: favoritesProvider),
        ChangeNotifierProvider<BuildGiftProvider>.value(value: buildGiftProvider),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: home,
        initialRoute: initialRoute,
      ),
    );
  }

  group('Cart Screen - Empty Basket State', () {
    testWidgets('Renders friendly empty basket state with both action buttons',
        (tester) async {
      await tester.pumpWidget(buildTestApp(home: const CartScreen()));
      await tester.pumpAndSettle();

      expect(find.text("Your gift basket is waiting 🎁"), findsOneWidget);
      expect(
        find.text("Find something thoughtful and start building a gift they'll love."),
        findsOneWidget,
      );
      expect(find.text('Explore Gifts'), findsOneWidget);
      expect(find.text('Build a Gift Box'), findsOneWidget);
    });
  });

  group('Cart Screen - Items, Quantities & Removal', () {
    testWidgets('Renders normal product with quantity stepper and price',
        (tester) async {
      cartProvider.addItem(product: sampleProduct);

      await tester.pumpWidget(buildTestApp(home: const CartScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Your Gift Basket'), findsOneWidget);
      expect(find.text('Handmade Lavender Candle'), findsOneWidget);
      expect(find.text('Aura Studio'), findsOneWidget);
      expect(find.text('1'), findsWidgets); // Quantity 1

      // Increment quantity
      final plusButton = find.byKey(Key('cart_increment_${cartProvider.items.first.id}'));
      await tester.tap(plusButton);
      await tester.pumpAndSettle();

      expect(cartProvider.items.first.quantity, equals(2));
      expect(cartProvider.subtotal, equals(3000.0));

      // Decrement quantity back to 1
      final minusButton = find.byKey(Key('cart_decrement_${cartProvider.items.first.id}'));
      await tester.tap(minusButton);
      await tester.pumpAndSettle();

      expect(cartProvider.items.first.quantity, equals(1));
      expect(cartProvider.subtotal, equals(1500.0));

      // Decrement again does not go below 1
      await tester.tap(minusButton);
      await tester.pumpAndSettle();

      expect(cartProvider.items.first.quantity, equals(1));

      // Remove item
      final removeButton = find.byKey(Key('cart_remove_${cartProvider.items.first.id}'));
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      expect(cartProvider.items.isEmpty, isTrue);
      expect(find.text("Your gift basket is waiting 🎁"), findsOneWidget);
    });

    testWidgets('Renders Custom Gift Box item and allows editing and removal',
        (tester) async {
      final sampleGiftBox = GiftBoxModel(
        id: 'box_99',
        boxTitle: 'Personalized Warmth',
        packagingStyle: 'Soft & Romantic',
        personalMessage: 'Happy Birthday to my dearest!',
        photoPath: 'assets/sample.jpg',
        items: [
          GiftBoxItem(product: sampleProduct, quantity: 1),
          GiftBoxItem(product: sampleProduct2, quantity: 1),
        ],
        createdAt: DateTime.now(),
      );

      cartProvider.addGiftBox(sampleGiftBox);

      await tester.pumpWidget(buildTestApp(home: const CartScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Custom Gift Box'), findsOneWidget);
      expect(find.text('2 curated gifts included'), findsOneWidget);
      expect(find.text('Style: Soft & Romantic'), findsOneWidget);
      expect(find.text('Personal note included 💌'), findsOneWidget);
      expect(find.text('Edit Gift Box'), findsOneWidget);

      // Tap Edit Gift Box
      await tester.tap(find.text('Edit Gift Box'));
      await tester.pumpAndSettle();

      // Should have populated buildGiftProvider
      expect(buildGiftProvider.items.length, equals(2));
      expect(buildGiftProvider.packagingStyle, equals('Soft & Romantic'));
      expect(buildGiftProvider.personalMessage, equals('Happy Birthday to my dearest!'));
    });
  });

  group('Cart Summary & Coupon Code Logic', () {
    testWidgets('Applies 10% discount for WELCOME10 coupon dynamically',
        (tester) async {
      cartProvider.addItem(product: sampleProduct, quantity: 2); // Subtotal: 3000

      await tester.pumpWidget(buildTestApp(home: const CartScreen()));
      await tester.pumpAndSettle();

      expect(find.text('PKR 3,000'), findsWidgets); // Subtotal
      expect(find.text('PKR 200'), findsOneWidget); // Delivery

      // Total before coupon: 3000 + 200 = 3200
      expect(find.text('PKR 3,200'), findsOneWidget);

      // Apply valid coupon WELCOME10
      final couponInput = find.byKey(const Key('coupon_input_field'));
      await tester.ensureVisible(couponInput);
      await tester.enterText(couponInput, 'welcome10');
      final applyButton = find.byKey(const Key('apply_coupon_button'));
      await tester.ensureVisible(applyButton);
      await tester.tap(applyButton);
      await tester.pumpAndSettle();

      // Discount = 10% of 3000 = 300
      expect(cartProvider.appliedCoupon, equals('WELCOME10'));
      expect(cartProvider.discount, equals(300.0));
      // New total = 3000 + 200 - 300 = 2900
      expect(cartProvider.total, equals(2900.0));
      expect(find.text('WELCOME10 applied (10% off)'), findsOneWidget);
      expect(find.text('- PKR 300'), findsOneWidget);
      expect(find.text('PKR 2,900'), findsOneWidget);

      // Remove coupon
      final removeCouponBtn = find.byKey(const Key('remove_coupon_button'));
      await tester.ensureVisible(removeCouponBtn);
      await tester.tap(removeCouponBtn);
      await tester.pumpAndSettle();

      expect(cartProvider.appliedCoupon, isNull);
      expect(cartProvider.discount, equals(0.0));
      expect(cartProvider.total, equals(3200.0));
    });

    testWidgets('Displays error message for invalid coupon code', (tester) async {
      cartProvider.addItem(product: sampleProduct);

      await tester.pumpWidget(buildTestApp(home: const CartScreen()));
      await tester.pumpAndSettle();

      final couponInput = find.byKey(const Key('coupon_input_field'));
      await tester.ensureVisible(couponInput);
      await tester.enterText(couponInput, 'INVALIDCODE');
      final applyButton = find.byKey(const Key('apply_coupon_button'));
      await tester.ensureVisible(applyButton);
      await tester.tap(applyButton);
      await tester.pumpAndSettle();

      expect(find.text("That coupon isn't valid."), findsOneWidget);
      expect(cartProvider.appliedCoupon, isNull);
    });
  });

  group('Checkout Screen - Delivery Form & Validation', () {
    testWidgets('Validates required delivery fields before proceeding to Review',
        (tester) async {
      cartProvider.addItem(product: sampleProduct);

      await tester.pumpWidget(buildTestApp(home: const CheckoutScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Where should we deliver it?'), findsOneWidget);
      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('More payment options will be available soon.'), findsOneWidget);

      // Attempt to proceed without entering details
      await tester.tap(find.byKey(const Key('checkout_continue_button')));
      await tester.pumpAndSettle();

      // Validation errors should be visible
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter a valid phone number'), findsOneWidget);
      expect(find.text('Please enter the delivery address'), findsOneWidget);
      expect(find.text('Enter city'), findsOneWidget);

      // Fill in valid details
      await tester.enterText(find.byKey(const Key('checkout_name_field')), 'Fatima Ali');
      await tester.enterText(find.byKey(const Key('checkout_phone_field')), '03001234567');
      await tester.enterText(
          find.byKey(const Key('checkout_address_field')), 'House 12, Street 4, Gulberg');
      await tester.enterText(find.byKey(const Key('checkout_city_field')), 'Lahore');
      await tester.enterText(find.byKey(const Key('checkout_postal_field')), '54000');
      await tester.enterText(
          find.byKey(const Key('checkout_note_field')), 'Please ring bell twice.');
      await tester.pumpAndSettle();

      // Proceed to review
      await tester.tap(find.byKey(const Key('checkout_continue_button')));
      await tester.pumpAndSettle();

      // Should now be on Step 3: Review
      expect(find.text('Review Your Order'), findsOneWidget);
      expect(find.text('Recipient'), findsOneWidget);
      expect(find.text('Fatima Ali'), findsOneWidget);
      expect(find.text('Lahore, 54000'), findsOneWidget);
      expect(find.text('Please ring bell twice.'), findsOneWidget);
      expect(find.text('Place Order'), findsOneWidget);

      // Tap Edit to go back to details
      await tester.tap(find.byKey(const Key('edit_delivery_details_button')));
      await tester.pumpAndSettle();

      expect(find.text('Where should we deliver it?'), findsOneWidget);
    });
  });

  group('Order Placement, Persistence & Success Flow', () {
    testWidgets('Places order, clears cart, persists to OrderProvider, and shows success',
        (tester) async {
      cartProvider.addItem(product: sampleProduct, quantity: 1); // 1500

      await tester.pumpWidget(buildTestApp(home: const CheckoutScreen()));
      await tester.pumpAndSettle();

      // Fill delivery details
      await tester.enterText(find.byKey(const Key('checkout_name_field')), 'Zainab Bibi');
      await tester.enterText(find.byKey(const Key('checkout_phone_field')), '03217654321');
      await tester.enterText(
          find.byKey(const Key('checkout_address_field')), 'Apartment 4B, Phase 5, DHA');
      await tester.enterText(find.byKey(const Key('checkout_city_field')), 'Karachi');

      // Continue to Review
      await tester.tap(find.byKey(const Key('checkout_continue_button')));
      await tester.pumpAndSettle();

      // Place order
      await tester.tap(find.byKey(const Key('checkout_place_order_button')));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Cart items should be cleared
      expect(cartProvider.items.isEmpty, isTrue);

      // Order should be persisted in OrderProvider
      expect(orderProvider.orders.length, equals(1));
      final placedOrder = orderProvider.orders.first;
      expect(placedOrder.customerName, equals('Zainab Bibi'));
      expect(placedOrder.city, equals('Karachi'));
      expect(placedOrder.status, equals('pending'));
      expect(placedOrder.paymentMethod, equals('Cash on Delivery'));
      expect(placedOrder.total, equals(1700.0)); // 1500 + 200 delivery

      // Verify Order Success screen contents
      expect(find.text('Order placed successfully.'), findsOneWidget);
      expect(
        find.text('Your gift is on its way to becoming something special!'),
        findsOneWidget,
      );
      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('Karachi'), findsOneWidget);
      expect(find.text('PKR 1700'), findsOneWidget);
      expect(find.text('View My Orders'), findsOneWidget);
      expect(find.text('Continue Shopping'), findsOneWidget);
    });
  });

  group('Orders Screen Integration', () {
    testWidgets('Renders placed orders retrieved from OrderProvider',
        (tester) async {
      final order = OrderModel(
        id: 'GN-100293',
        customerName: 'Ahmad Hassan',
        phone: '03331112233',
        address: 'Sector F-7/2',
        city: 'Islamabad',
        paymentMethod: 'Cash on Delivery',
        items: [
          CartItemModel(
            id: 'item_1',
            product: sampleProduct,
            quantity: 2,
          ),
        ],
        subtotal: 3000.0,
        deliveryFee: 200.0,
        discount: 0.0,
        total: 3200.0,
        status: 'pending',
        createdAt: DateTime(2026, 9, 25),
      );

      await orderProvider.placeOrder(order);

      await tester.pumpWidget(buildTestApp(home: const OrdersScreen()));
      await tester.pumpAndSettle();

      expect(find.text('GN-100293'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.text('Delivering to Ahmad Hassan'), findsOneWidget);
      expect(find.text('Islamabad • Cash on Delivery'), findsOneWidget);
      expect(find.text('PKR 3200'), findsOneWidget);
    });
  });

  group('Small Screen Responsiveness', () {
    testWidgets('CartScreen renders cleanly on small device (360x640) without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      cartProvider.addItem(product: sampleProduct);

      await tester.pumpWidget(buildTestApp(home: const CartScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('CheckoutScreen renders cleanly on small device (360x640) without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      cartProvider.addItem(product: sampleProduct);

      await tester.pumpWidget(buildTestApp(home: const CheckoutScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Where should we deliver it?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
