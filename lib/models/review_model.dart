/// Represents a customer review for a gift or creator.
class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String? ?? '',
      productId: map['productId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Verified Buyer',
      userAvatarUrl: map['userAvatarUrl'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      comment: map['comment'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
