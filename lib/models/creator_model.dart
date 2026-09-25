/// Represents a local creator or boutique artisan on Gift Nest.
class CreatorModel {
  final String id;
  final String name;
  final String studioName;
  final String? bio;
  final String? avatarUrl;
  final String? bannerUrl;
  final String location;
  final double rating;
  final int totalProducts;
  final bool isVerified;

  const CreatorModel({
    required this.id,
    required this.name,
    required this.studioName,
    this.bio,
    this.avatarUrl,
    this.bannerUrl,
    this.location = '',
    this.rating = 5.0,
    this.totalProducts = 0,
    this.isVerified = false,
  });

  CreatorModel copyWith({
    String? id,
    String? name,
    String? studioName,
    String? bio,
    String? avatarUrl,
    String? bannerUrl,
    String? location,
    double? rating,
    int? totalProducts,
    bool? isVerified,
  }) {
    return CreatorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      studioName: studioName ?? this.studioName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      totalProducts: totalProducts ?? this.totalProducts,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studioName': studioName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'bannerUrl': bannerUrl,
      'location': location,
      'rating': rating,
      'totalProducts': totalProducts,
      'isVerified': isVerified,
    };
  }

  factory CreatorModel.fromMap(Map<String, dynamic> map) {
    return CreatorModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      studioName: map['studioName'] as String? ?? '',
      bio: map['bio'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      bannerUrl: map['bannerUrl'] as String?,
      location: map['location'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      totalProducts: map['totalProducts'] as int? ?? 0,
      isVerified: map['isVerified'] as bool? ?? false,
    );
  }
}
