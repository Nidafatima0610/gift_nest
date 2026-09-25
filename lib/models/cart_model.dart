import 'product_model.dart';

/// Represents a single line item in the shopping cart.
class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;
  final Map<String, String>? personalizations;
  final String? giftRecipientNote;

  const CartItemModel({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.personalizations,
    this.giftRecipientNote,
  });

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    Map<String, String>? personalizations,
    String? giftRecipientNote,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      personalizations: personalizations ?? this.personalizations,
      giftRecipientNote: giftRecipientNote ?? this.giftRecipientNote,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
      'personalizations': personalizations,
      'giftRecipientNote': giftRecipientNote,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as String? ?? '',
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>? ?? {}),
      quantity: map['quantity'] as int? ?? 1,
      personalizations: map['personalizations'] != null
          ? Map<String, String>.from(map['personalizations'] as Map)
          : null,
      giftRecipientNote: map['giftRecipientNote'] as String?,
    );
  }
}

/// Represents the active user cart.
class CartModel {
  final String id;
  final List<CartItemModel> items;
  final String? overallGiftNote;
  final bool includeGiftPackaging;
  final double deliveryFee;

  const CartModel({
    required this.id,
    this.items = const [],
    this.overallGiftNote,
    this.includeGiftPackaging = true,
    this.deliveryFee = 0.0,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal + deliveryFee;

  CartModel copyWith({
    String? id,
    List<CartItemModel>? items,
    String? overallGiftNote,
    bool? includeGiftPackaging,
    double? deliveryFee,
  }) {
    return CartModel(
      id: id ?? this.id,
      items: items ?? this.items,
      overallGiftNote: overallGiftNote ?? this.overallGiftNote,
      includeGiftPackaging: includeGiftPackaging ?? this.includeGiftPackaging,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((i) => i.toMap()).toList(),
      'overallGiftNote': overallGiftNote,
      'includeGiftPackaging': includeGiftPackaging,
      'deliveryFee': deliveryFee,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as String? ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
              .toList() ??
          const [],
      overallGiftNote: map['overallGiftNote'] as String?,
      includeGiftPackaging: map['includeGiftPackaging'] as bool? ?? true,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
