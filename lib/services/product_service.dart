import '../models/category_model.dart';
import '../models/creator_model.dart';
import '../models/product_model.dart';

/// Contract for Product and Catalog data retrieval.
/// Ready to connect to Cloud Firestore or REST backend.
abstract class ProductService {
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? recipient,
    String? occasion,
    double? maxBudget,
    String? interest,
  });

  Future<ProductModel?> getProductById(String id);

  Future<List<ProductModel>> getPopularProducts();

  Future<List<CategoryModel>> getCategories();

  Future<List<CreatorModel>> getFeaturedCreators();

  Future<List<ProductModel>> searchProducts(String query);
}

/// Initial implementation stub for [ProductService].
/// Cloud Firestore or API queries will be implemented here.
class ProductServiceImpl implements ProductService {
  @override
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? recipient,
    String? occasion,
    double? maxBudget,
    String? interest,
  }) async {
    // Firestore query will be connected here
    return [];
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    // Firestore query will be connected here
    return null;
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    // Firestore query will be connected here
    return [];
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    // Firestore query will be connected here
    return [];
  }

  @override
  Future<List<CreatorModel>> getFeaturedCreators() async {
    // Firestore query will be connected here
    return [];
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    // Firestore query will be connected here
    return [];
  }
}
