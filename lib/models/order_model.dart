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
  final String customerName;
  final String phone;
  final String address;
  final String city;
  final String? postalCode;
  final String? deliveryNote;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String status; // 'pending', 'placed', 'packaging', 'shipped', 'delivered', 'cancelled'
  final DateTime createdAt;
  final DateTime? estimatedDeliveryDate;

  // Backward compatibility getters
  double get totalAmount => total;
  String get shippingAddress => address;
  String? get recipientName => customerName;
  String? get recipientPhone => phone;
  String? get giftNote => deliveryNote;
  OrderStatus get orderStatus {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => OrderStatus.placed,
    );
  }

  static double _calculateSubtotal(List<CartItemModel> items) {
    var sum = 0.0;
    for (final item in items) {
      sum += item.totalPrice;
    }
    return sum;
  }

  OrderModel({
    required this.id,
    this.userId = 'guest_user',
    required this.items,
    String? customerName,
    String? phone,
    String? address,
    this.city = 'Lahore',
    this.postalCode,
    String? deliveryNote,
    this.paymentMethod = 'Cash on Delivery',
    double? subtotal,
    this.deliveryFee = 200.0,
    this.discount = 0.0,
    double? total,
    this.status = 'pending',
    required this.createdAt,
    this.estimatedDeliveryDate,
    // Backward compatibility constructor parameters
    String? shippingAddress,
    String? recipientName,
    String? recipientPhone,
    String? giftNote,
    double? totalAmount,
    OrderStatus? statusEnum,
  })  : customerName = customerName ?? recipientName ?? 'Customer',
        phone = phone ?? recipientPhone ?? '',
        address = address ?? shippingAddress ?? '',
        deliveryNote = deliveryNote ?? giftNote,
        subtotal = subtotal ?? _calculateSubtotal(items),
        total = total ??
            totalAmount ??
            ((subtotal ?? _calculateSubtotal(items)) +
                deliveryFee -
                discount);

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    String? customerName,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
    String? deliveryNote,
    String? paymentMethod,
    double? subtotal,
    double? deliveryFee,
    double? discount,
    double? total,
    String? status,
    DateTime? createdAt,
    DateTime? estimatedDeliveryDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      deliveryNote: deliveryNote ?? this.deliveryNote,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
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
      'customerName': customerName,
      'recipientName': customerName,
      'phone': phone,
      'recipientPhone': phone,
      'address': address,
      'shippingAddress': address,
      'city': city,
      'postalCode': postalCode,
      'deliveryNote': deliveryNote,
      'giftNote': deliveryNote,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'totalAmount': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final parsedItems = (map['items'] as List<dynamic>?)
            ?.map((i) => CartItemModel.fromMap(i as Map<String, dynamic>))
            .toList() ??
        const [];

    final subtotal = (map['subtotal'] as num?)?.toDouble() ??
        _calculateSubtotal(parsedItems);
    final deliveryFee = (map['deliveryFee'] as num?)?.toDouble() ?? 200.0;
    final discount = (map['discount'] as num?)?.toDouble() ?? 0.0;
    final total = ((map['total'] ?? map['totalAmount']) as num?)?.toDouble() ??
        (subtotal + deliveryFee - discount);

    return OrderModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? 'guest_user',
      items: parsedItems,
      customerName: (map['customerName'] ?? map['recipientName']) as String? ?? 'Customer',
      phone: (map['phone'] ?? map['recipientPhone']) as String? ?? '',
      address: (map['address'] ?? map['shippingAddress']) as String? ?? '',
      city: map['city'] as String? ?? 'Lahore',
      postalCode: map['postalCode'] as String?,
      deliveryNote: (map['deliveryNote'] ?? map['giftNote']) as String?,
      paymentMethod: map['paymentMethod'] as String? ?? 'Cash on Delivery',
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      status: map['status'] as String? ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      estimatedDeliveryDate: map['estimatedDeliveryDate'] != null
          ? DateTime.tryParse(map['estimatedDeliveryDate'] as String)
          : null,
    );
  }
}
