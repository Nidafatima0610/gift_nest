import '../models/order_model.dart';

/// Contract for Order processing and tracking.
abstract class OrderService {
  Future<OrderModel> createOrder(OrderModel order);
  Future<List<OrderModel>> getUserOrders(String userId);
  Future<OrderModel?> getOrderById(String orderId);
}

/// Initial implementation stub for [OrderService].
class OrderServiceImpl implements OrderService {
  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    throw UnimplementedError('Order service will be connected to Firebase/backend');
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    return [];
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    return null;
  }
}
