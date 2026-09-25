import '../models/cart_model.dart';

/// Contract for Cart persistence service (local / cloud sync).
abstract class CartService {
  Future<CartModel?> getCart(String userId);
  Future<void> saveCart(String userId, CartModel cart);
  Future<void> clearCart(String userId);
}

/// Initial implementation stub for [CartService].
class CartServiceImpl implements CartService {
  @override
  Future<CartModel?> getCart(String userId) async {
    return null;
  }

  @override
  Future<void> saveCart(String userId, CartModel cart) async {
    // Sync with remote/local storage
  }

  @override
  Future<void> clearCart(String userId) async {
    // Clear storage
  }
}
