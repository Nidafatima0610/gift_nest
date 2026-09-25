/// Represents a user within the Gift Nest marketplace.
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? phoneNumber;
  final List<String> favoriteProductIds;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    this.favoriteProductIds = const [],
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
    List<String>? favoriteProductIds,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'favoriteProductIds': favoriteProductIds,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      favoriteProductIds: List<String>.from(map['favoriteProductIds'] ?? const []),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }
}
