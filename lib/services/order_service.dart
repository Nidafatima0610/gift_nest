import '../models/order_model.dart';

/// Contract for Order processing and tracking.
abstract class OrderService {
  Future<OrderModel> createOrder(OrderModel order);
  Future<List<OrderModel>> getUserOrders(String userId);
  Future<OrderModel?> getOrderById(String orderId);
}

/// Local demo implementation for [OrderService].
class OrderServiceImpl implements OrderService {
  final List<OrderModel> _localOrders = [];

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    _localOrders.insert(0, order);
    return order;
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    return List.unmodifiable(_localOrders);
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    final matches = _localOrders.where((o) => o.id == orderId);
    return matches.isNotEmpty ? matches.first : null;
  }
}
