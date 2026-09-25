import 'cart_model.dart';

enum OrderStatus {
  placed,
  packaging,
  shipped,
  delivered,
  cancelled,
}

/// Represents an order placed by a customer on Gift Nest.
class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final double deliveryFee;
  final OrderStatus status;
  final String shippingAddress;
  final String? recipientName;
  final String? recipientPhone;
  final String? giftNote;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryDate;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.deliveryFee = 0.0,
    this.status = OrderStatus.placed,
    required this.shippingAddress,
    this.recipientName,
    this.recipientPhone,
    this.giftNote,
    required this.createdAt,
    this.estimatedDeliveryDate,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    double? totalAmount,
    double? deliveryFee,
    OrderStatus? status,
    String? shippingAddress,
    String? recipientName,
    String? recipientPhone,
    String? giftNote,
    DateTime? createdAt,
    DateTime? estimatedDeliveryDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      giftNote: giftNote ?? this.giftNote,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryDate:
          estimatedDeliveryDate ?? this.estimatedDeliveryDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((i) => i.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'status': status.name,
      'shippingAddress': shippingAddress,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'giftNote': giftNote,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((i) => CartItemModel.fromMap(i as Map<String, dynamic>))
              .toList() ??
          const [],
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.placed,
      ),
      shippingAddress: map['shippingAddress'] as String? ?? '',
      recipientName: map['recipientName'] as String?,
      recipientPhone: map['recipientPhone'] as String?,
      giftNote: map['giftNote'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      estimatedDeliveryDate: map['estimatedDeliveryDate'] != null
          ? DateTime.tryParse(map['estimatedDeliveryDate'] as String)
          : null,
    );
  }
}
