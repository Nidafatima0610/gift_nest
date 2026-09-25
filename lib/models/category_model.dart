/// Represents a gift category (e.g. Birthday, Anniversary, Handcrafted, Gourmets).
class CategoryModel {
  final String id;
  final String name;
  final String? iconName;
  final String? imageUrl;
  final String? description;

  const CategoryModel({
    required this.id,
    required this.name,
    this.iconName,
    this.imageUrl,
    this.description,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconName,
    String? imageUrl,
    String? description,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      iconName: map['iconName'] as String?,
      imageUrl: map['imageUrl'] as String?,
      description: map['description'] as String?,
    );
  }
}
