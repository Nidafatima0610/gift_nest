import 'package:flutter/foundation.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';

/// Manages shopping cart state and gifting customizations.
class CartProvider extends ChangeNotifier {
  CartModel _cart = const CartModel(id: 'active_cart');

  CartModel get cart => _cart;
  List<CartItemModel> get items => _cart.items;
  int get itemCount => _cart.totalItemCount;
  double get subtotal => _cart.subtotal;
  double get total => _cart.total;
  bool get isEmpty => _cart.items.isEmpty;

  void addItem({
    required ProductModel product,
    int quantity = 1,
    Map<String, String>? personalizations,
    String? giftNote,
  }) {
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
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
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          quantity: quantity,
          personalizations: personalizations,
          giftRecipientNote: giftNote,
        ),
      );
    }

    _cart = _cart.copyWith(items: updatedItems);
    notifyListeners();
  }

  void removeItem(String itemId) {
    final updatedItems = _cart.items.where((item) => item.id != itemId).toList();
    _cart = _cart.copyWith(items: updatedItems);
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
    notifyListeners();
  }

  void updateGiftNote(String note) {
    _cart = _cart.copyWith(overallGiftNote: note);
    notifyListeners();
  }

  void toggleGiftPackaging(bool include) {
    _cart = _cart.copyWith(includeGiftPackaging: include);
    notifyListeners();
  }

  void clearCart() {
    _cart = const CartModel(id: 'active_cart');
    notifyListeners();
  }
}
