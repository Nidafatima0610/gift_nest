import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

/// Manages order history, placement, and local persistence for Gift Nest.
class OrderProvider extends ChangeNotifier {
  static const String _storageKey = 'user_orders_data';
  final OrderService _orderService;

  OrderProvider({OrderService? orderService})
      : _orderService = orderService ?? OrderServiceImpl();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  /// Loads orders from local storage.
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        _orders = list
            .map((item) => OrderModel.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading orders: $e');
      _isInitialized = true;
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_orders.map((o) => o.toMap()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }

  Future<void> fetchUserOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _orderService.getUserOrders(userId);
      if (fetched.isNotEmpty) {
        _orders = fetched;
        await _persist();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Places a new order, saves to memory and local storage, and notifies listeners.
  Future<OrderModel?> placeOrder(OrderModel order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdOrder = await _orderService.createOrder(order);
      _orders = [createdOrder, ..._orders];
      await _persist();

      _isLoading = false;
      notifyListeners();
      return createdOrder;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Clears stored orders.
  Future<void> clearOrders() async {
    _orders = [];
    await _persist();
    notifyListeners();
  }
}
