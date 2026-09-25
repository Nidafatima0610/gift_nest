import 'package:flutter/foundation.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

/// Manages order history and placement state using Provider.
class OrderProvider extends ChangeNotifier {
  final OrderService _orderService;

  OrderProvider({OrderService? orderService})
      : _orderService = orderService ?? OrderServiceImpl();

  List<OrderModel> _orders = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderService.getUserOrders(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<OrderModel?> placeOrder(OrderModel order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdOrder = await _orderService.createOrder(order);
      _orders = [createdOrder, ..._orders];
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
}
