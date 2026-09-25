import 'product_model.dart';

/// Represents a single product selection with quantity within a Gift Box.
class GiftBoxItem {
  final ProductModel product;
  final int quantity;

  const GiftBoxItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  GiftBoxItem copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return GiftBoxItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory GiftBoxItem.fromMap(Map<String, dynamic> map) {
    return GiftBoxItem(
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>? ?? {}),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Represents a custom-curated Gift Box built by the user.
class GiftBoxModel {
  static const double defaultServiceFee = 199.0;

  final String id;
  final String boxTitle;
  final String packagingStyle; // 'Classic', 'Soft & Romantic', 'Minimal', 'Festive', 'Cute'
  final String? personalMessage;
  final String? photoPath;
  final List<GiftBoxItem> items;
  final double serviceFee;
  final DateTime createdAt;

  // Legacy compatibility fields
  final String? boxStyle;
  final double? boxBasePrice;
  final String? ribbonColor;
  final String? greetingCardDesign;
  final String? personalNote;
  final String? recipientName;
  final List<ProductModel>? selectedProducts;

  GiftBoxModel({
    required this.id,
    this.boxTitle = 'My Custom Gift Box',
    String? packagingStyle,
    this.personalMessage,
    this.photoPath,
    List<GiftBoxItem>? items,
    double? serviceFee,
    DateTime? createdAt,
    this.boxStyle,
    this.boxBasePrice,
    this.ribbonColor = 'Dusty Rose',
    this.greetingCardDesign = 'Floral Bloom',
    this.personalNote,
    this.recipientName,
    this.selectedProducts,
  })  : packagingStyle = packagingStyle ?? boxStyle ?? 'Classic',
        serviceFee = serviceFee ?? boxBasePrice ?? defaultServiceFee,
        createdAt = createdAt ?? DateTime.now(),
        items = items ??
            (selectedProducts != null
                ? selectedProducts.map((p) => GiftBoxItem(product: p, quantity: 1)).toList()
                : const []);

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal + serviceFee;

  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  // Backward compatibility getters
  double get itemsTotal => subtotal;
  double get totalPrice => total;

  GiftBoxModel copyWith({
    String? id,
    String? boxTitle,
    String? packagingStyle,
    String? personalMessage,
    String? photoPath,
    List<GiftBoxItem>? items,
    double? serviceFee,
    DateTime? createdAt,
    String? boxStyle,
    double? boxBasePrice,
    String? ribbonColor,
    String? greetingCardDesign,
    String? personalNote,
    String? recipientName,
    List<ProductModel>? selectedProducts,
  }) {
    return GiftBoxModel(
      id: id ?? this.id,
      boxTitle: boxTitle ?? this.boxTitle,
      packagingStyle: packagingStyle ?? this.packagingStyle,
      personalMessage: personalMessage ?? this.personalMessage,
      photoPath: photoPath ?? this.photoPath,
      items: items ?? this.items,
      serviceFee: serviceFee ?? this.serviceFee,
      createdAt: createdAt ?? this.createdAt,
      boxStyle: boxStyle ?? this.boxStyle,
      boxBasePrice: boxBasePrice ?? this.boxBasePrice,
      ribbonColor: ribbonColor ?? this.ribbonColor,
      greetingCardDesign: greetingCardDesign ?? this.greetingCardDesign,
      personalNote: personalNote ?? this.personalNote,
      recipientName: recipientName ?? this.recipientName,
      selectedProducts: selectedProducts ?? this.selectedProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'boxTitle': boxTitle,
      'packagingStyle': packagingStyle,
      'boxStyle': packagingStyle,
      'personalMessage': personalMessage,
      'personalNote': personalMessage,
      'photoPath': photoPath,
      'items': items.map((i) => i.toMap()).toList(),
      'selectedProducts': items.map((i) => i.product.toMap()).toList(),
      'serviceFee': serviceFee,
      'boxBasePrice': serviceFee,
      'subtotal': subtotal,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'ribbonColor': ribbonColor,
      'greetingCardDesign': greetingCardDesign,
      'recipientName': recipientName,
    };
  }

  factory GiftBoxModel.fromMap(Map<String, dynamic> map) {
    List<GiftBoxItem> parsedItems = [];
    if (map['items'] != null) {
      parsedItems = (map['items'] as List<dynamic>)
          .map((i) => GiftBoxItem.fromMap(i as Map<String, dynamic>))
          .toList();
    } else if (map['selectedProducts'] != null) {
      parsedItems = (map['selectedProducts'] as List<dynamic>)
          .map((p) => GiftBoxItem(
                product: ProductModel.fromMap(p as Map<String, dynamic>),
                quantity: 1,
              ))
          .toList();
    }

    return GiftBoxModel(
      id: map['id'] as String? ?? '',
      boxTitle: map['boxTitle'] as String? ?? 'My Custom Gift Box',
      packagingStyle: (map['packagingStyle'] ?? map['boxStyle']) as String? ?? 'Classic',
      personalMessage: (map['personalMessage'] ?? map['personalNote']) as String?,
      photoPath: map['photoPath'] as String?,
      items: parsedItems,
      serviceFee: (map['serviceFee'] ?? map['boxBasePrice'] as num?)?.toDouble() ?? defaultServiceFee,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      ribbonColor: map['ribbonColor'] as String? ?? 'Dusty Rose',
      greetingCardDesign: map['greetingCardDesign'] as String? ?? 'Floral Bloom',
      recipientName: map['recipientName'] as String?,
    );
  }
}
