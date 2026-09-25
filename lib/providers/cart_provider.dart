import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';

/// Manages shopping cart state, gifting customizations, and local persistence.
class CartProvider extends ChangeNotifier {
  static const String _storageKey = 'user_cart_data';

  CartModel _cart = const CartModel(id: 'active_cart');
  bool _isInitialized = false;

  CartModel get cart => _cart;
  List<CartItemModel> get items => _cart.items;
  int get itemCount => _cart.totalItemCount;
  double get subtotal => _cart.subtotal;
  double get total => _cart.total;
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
          item.product.id == product.id &&
          mapEquals(item.personalizations, personalizations),
    );

    List<CartItemModel> updatedItems = List.from(_cart.items);

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
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
    _persist();
    notifyListeners();
  }

  void removeItem(String itemId) {
    final updatedItems = _cart.items.where((item) => item.id != itemId).toList();
    _cart = _cart.copyWith(items: updatedItems);
    _persist();
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedItems = _cart.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    _cart = _cart.copyWith(items: updatedItems);
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
    _persist();
    notifyListeners();
  }
}
