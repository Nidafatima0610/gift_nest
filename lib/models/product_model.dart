/// Represents a gift product on Gift Nest.
class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> imageUrls;
  final String categoryId;
  final String creatorId;
  final String? creatorName;
  final double rating;
  final int reviewCount;
  final bool isCustomizable;
  final List<String> customizableFields;
  final List<String> occasions;
  final List<String> recipients;
  final List<String> interests;
  final bool inStock;
  final bool isPopular;
  final bool isStaffPick;
  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    this.imageUrls = const [],
    required this.categoryId,
    required this.creatorId,
    this.creatorName,
    this.rating = 5.0,
    this.reviewCount = 0,
    this.isCustomizable = false,
    this.customizableFields = const [],
    this.occasions = const [],
    this.recipients = const [],
    this.interests = const [],
    this.inStock = true,
    this.isPopular = false,
    this.isStaffPick = false,
    this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    double? originalPrice,
    List<String>? imageUrls,
    String? categoryId,
    String? creatorId,
    String? creatorName,
    double? rating,
    int? reviewCount,
    bool? isCustomizable,
    List<String>? customizableFields,
    List<String>? occasions,
    List<String>? recipients,
    List<String>? interests,
    bool? inStock,
    bool? isPopular,
    bool? isStaffPick,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      categoryId: categoryId ?? this.categoryId,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isCustomizable: isCustomizable ?? this.isCustomizable,
      customizableFields: customizableFields ?? this.customizableFields,
      occasions: occasions ?? this.occasions,
      recipients: recipients ?? this.recipients,
      interests: interests ?? this.interests,
      inStock: inStock ?? this.inStock,
      isPopular: isPopular ?? this.isPopular,
      isStaffPick: isStaffPick ?? this.isStaffPick,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrls': imageUrls,
      'categoryId': categoryId,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'rating': rating,
      'reviewCount': reviewCount,
      'isCustomizable': isCustomizable,
      'customizableFields': customizableFields,
      'occasions': occasions,
      'recipients': recipients,
      'interests': interests,
      'inStock': inStock,
      'isPopular': isPopular,
      'isStaffPick': isStaffPick,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (map['originalPrice'] as num?)?.toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? const []),
      categoryId: map['categoryId'] as String? ?? '',
      creatorId: map['creatorId'] as String? ?? '',
      creatorName: map['creatorName'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      isCustomizable: map['isCustomizable'] as bool? ?? false,
      customizableFields: List<String>.from(map['customizableFields'] ?? const []),
      occasions: List<String>.from(map['occasions'] ?? const []),
      recipients: List<String>.from(map['recipients'] ?? const []),
      interests: List<String>.from(map['interests'] ?? const []),
      inStock: map['inStock'] as bool? ?? true,
      isPopular: map['isPopular'] as bool? ?? false,
      isStaffPick: map['isStaffPick'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }
}
