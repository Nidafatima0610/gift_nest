import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
import '../models/gift_box_model.dart';
import '../models/product_model.dart';

/// Manages shopping cart state, gifting customizations, coupons, and local persistence.
class CartProvider extends ChangeNotifier {
  static const String _storageKey = 'user_cart_data';
  static const double defaultDeliveryFee = 200.0;

  CartModel _cart = const CartModel(id: 'active_cart');
  bool _isInitialized = false;

  String? _appliedCoupon;
  double _discount = 0.0;

  CartModel get cart => _cart;
  List<CartItemModel> get items => _cart.items;
  List<GiftBoxModel> get giftBoxes =>
      _cart.items.where((item) => item.giftBox != null).map((item) => item.giftBox!).toList();
  int get itemCount => _cart.totalItemCount;
  double get subtotal => _cart.subtotal;
  double get deliveryFee => _cart.items.isEmpty ? 0.0 : defaultDeliveryFee;
  double get discount => _discount;
  String? get appliedCoupon => _appliedCoupon;
  double get total => (subtotal + deliveryFee - discount).clamp(0.0, double.infinity);
  bool get isEmpty => _cart.items.isEmpty;
  bool get isInitialized => _isInitialized;

  /// Loads cart data from SharedPreferences.
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        _cart = CartModel.fromMap(map);
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart data: $e');
      _isInitialized = true;
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_cart.toMap());
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      debugPrint('Error saving cart data: $e');
    }
  }

  void _recalculateDiscount() {
    if (_appliedCoupon == 'WELCOME10') {
      _discount = subtotal * 0.10;
    } else {
      _discount = 0.0;
    }
  }

  /// Applies demo coupon code. WELCOME10 gives 10% discount on subtotal.
  bool applyCoupon(String code) {
    final cleaned = code.trim().toUpperCase();
    if (cleaned == 'WELCOME10') {
      _appliedCoupon = 'WELCOME10';
      _recalculateDiscount();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Removes currently applied coupon.
  void removeCoupon() {
    _appliedCoupon = null;
    _discount = 0.0;
    notifyListeners();
  }

  /// Adds a product to the cart. If the product and personalizations match,
  /// increments quantity; otherwise creates a new line item.
  void addItem({
    required ProductModel product,
    int quantity = 1,
    Map<String, String>? personalizations,
    String? giftNote,
  }) {
    final existingIndex = _cart.items.indexWhere(
      (item) =>
          !item.isGiftBox &&
          item.product.id == product.id &&
          mapEquals(item.personalizations, personalizations),
    );

    List<CartItemModel> updatedItems = List.from(_cart.items);

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      final maxStock = product.inStock ? 10 : 1;
      final newQty = (existingItem.quantity + quantity).clamp(1, maxStock);
      updatedItems[existingIndex] = existingItem.copyWith(quantity: newQty);
    } else {
      updatedItems.add(
        CartItemModel(
          id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
          product: product,
          quantity: quantity,
          personalizations: personalizations != null && personalizations.isNotEmpty
              ? Map.from(personalizations)
              : null,
          giftRecipientNote: giftNote,
        ),
      );
    }

    _cart = _cart.copyWith(items: updatedItems);
    _recalculateDiscount();
    _persist();
    notifyListeners();
  }

  /// Adds a custom gift box to the cart.
  void addGiftBox(GiftBoxModel giftBox) {
    final boxCoverImage = giftBox.items.isNotEmpty && giftBox.items.first.product.imageUrls.isNotEmpty
        ? giftBox.items.first.product.imageUrls.first
        : '';
    final dummyProduct = ProductModel(
      id: 'box_${giftBox.id}',
      title: 'Custom Gift Box (${giftBox.packagingStyle})',
      description: '${giftBox.items.length} curated gifts with ${giftBox.packagingStyle} packaging',
      price: giftBox.total,
      imageUrls: boxCoverImage.isNotEmpty ? [boxCoverImage] : const [],
      categoryId: 'gift_box',
      creatorId: 'gift_nest',
      creatorName: 'Gift Nest Studio',
      rating: 5.0,
      reviewCount: 1,
      createdAt: giftBox.createdAt,
    );

    final cartItem = CartItemModel(
      id: 'giftbox_${giftBox.id}_${DateTime.now().millisecondsSinceEpoch}',
      product: dummyProduct,
      quantity: 1,
      giftRecipientNote: giftBox.personalMessage,
      giftBox: giftBox,
    );

    final updatedItems = List<CartItemModel>.from(_cart.items)..add(cartItem);
    _cart = _cart.copyWith(items: updatedItems);
    _recalculateDiscount();
    _persist();
    notifyListeners();
  }

  void removeItem(String itemId) {
    final updatedItems = _cart.items.where((item) => item.id != itemId).toList();
    _cart = _cart.copyWith(items: updatedItems);
    _recalculateDiscount();
    _persist();
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity < 1) return;

    final updatedItems = _cart.items.map((item) {
      if (item.id == itemId) {
        if (item.isGiftBox) {
          return item; // Custom gift box is treated as a single complete unit
        }
        final maxStock = item.product.inStock ? 10 : 1;
        final clamped = newQuantity.clamp(1, maxStock);
        return item.copyWith(quantity: clamped);
      }
      return item;
    }).toList();

    _cart = _cart.copyWith(items: updatedItems);
    _recalculateDiscount();
    _persist();
    notifyListeners();
  }

  void updateGiftNote(String note) {
    _cart = _cart.copyWith(overallGiftNote: note);
    _persist();
    notifyListeners();
  }

  void toggleGiftPackaging(bool include) {
    _cart = _cart.copyWith(includeGiftPackaging: include);
    _persist();
    notifyListeners();
  }

  void clearCart() {
    _cart = const CartModel(id: 'active_cart');
    _appliedCoupon = null;
    _discount = 0.0;
    _persist();
    notifyListeners();
  }
}
