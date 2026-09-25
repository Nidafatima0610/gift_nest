import 'product_model.dart';

/// Represents a custom-curated Gift Box built by the user.
class GiftBoxModel {
  final String id;
  final String boxTitle;
  final String boxStyle; // e.g., 'Kraft Minimalist', 'Rose Velvet Keepsake', 'Wooden Crate'
  final double boxBasePrice;
  final String ribbonColor; // e.g., 'Dusty Rose', 'Antique Gold', 'Plum'
  final String greetingCardDesign;
  final String? personalNote;
  final String? recipientName;
  final List<ProductModel> selectedProducts;

  const GiftBoxModel({
    required this.id,
    this.boxTitle = 'My Custom Gift Box',
    this.boxStyle = 'Rose Velvet Keepsake',
    this.boxBasePrice = 12.0,
    this.ribbonColor = 'Dusty Rose',
    this.greetingCardDesign = 'Floral Bloom',
    this.personalNote,
    this.recipientName,
    this.selectedProducts = const [],
  });

  double get itemsTotal =>
      selectedProducts.fold(0.0, (sum, product) => sum + product.price);

  double get totalPrice => boxBasePrice + itemsTotal;

  GiftBoxModel copyWith({
    String? id,
    String? boxTitle,
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
      'boxStyle': boxStyle,
      'boxBasePrice': boxBasePrice,
      'ribbonColor': ribbonColor,
      'greetingCardDesign': greetingCardDesign,
      'personalNote': personalNote,
      'recipientName': recipientName,
      'selectedProducts': selectedProducts.map((p) => p.toMap()).toList(),
    };
  }

  factory GiftBoxModel.fromMap(Map<String, dynamic> map) {
    return GiftBoxModel(
      id: map['id'] as String? ?? '',
      boxTitle: map['boxTitle'] as String? ?? 'My Custom Gift Box',
      boxStyle: map['boxStyle'] as String? ?? 'Rose Velvet Keepsake',
      boxBasePrice: (map['boxBasePrice'] as num?)?.toDouble() ?? 12.0,
      ribbonColor: map['ribbonColor'] as String? ?? 'Dusty Rose',
      greetingCardDesign: map['greetingCardDesign'] as String? ?? 'Floral Bloom',
      personalNote: map['personalNote'] as String?,
      recipientName: map['recipientName'] as String?,
      selectedProducts: (map['selectedProducts'] as List<dynamic>?)
              ?.map((p) => ProductModel.fromMap(p as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
